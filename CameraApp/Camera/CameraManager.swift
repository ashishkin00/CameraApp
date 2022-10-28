import UIKit
import AVFoundation
import Photos
import PhotosUI

class CameraManager: NSObject {
    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureMovieFileOutput()
    var currentFrontInput: AVCaptureDeviceInput!
    var currentBackInput: AVCaptureDeviceInput!
    lazy var frontInputs: [AVCaptureDeviceInput] = []
    lazy var backInputs: [AVCaptureDeviceInput] = []
    lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    lazy var zoomFactor: CGFloat = 1
    lazy var position: CameraPosition = .back
    lazy var flashMode: FlashModes = .auto
    weak var vcDelegate: ViewControllerDelegate?
    weak var uiDelegate: CameraUIDelegate?
    
    func start() {
        requestCaptureAccess { [self] granted in
            if granted {
                DispatchQueue.main.async {
                    self.setupCameraModules()
                }
            } else {
                DispatchQueue.main.async {
                    self.vcDelegate?.showAlert(title: "Can't access camera", msg: "Please provide access to the camera in your device settings", actions: [UIAlertAction(title: "OK", style: .default, handler: { _ in
                        exit(0)
                    })])
                }
            }
        }
        requestLibraryAccess { granted in
            if granted {
                DispatchQueue.main.async {
                    self.vcDelegate?.refreshPreviewImage()
                }
            }
        }
    }
    
    func setupCameraModules() {
        let backModules = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera], mediaType: .video, position: .back)
        let frontModules = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera], mediaType: .video, position: .front)
        session.beginConfiguration()
        for module in frontModules.devices {
            do {
                let input = try AVCaptureDeviceInput(device: module)
                if session.canAddInput(input) {
                    frontInputs.append(input)
                }
            } catch {
                print("uh-oh")
            }
        }
        for module in backModules.devices {
            do {
                let input = try AVCaptureDeviceInput(device: module)
                if session.canAddInput(input) {
                    backInputs.append(input)
                    
                }
            } catch {
                print("uh-oh")
            }
        }
        currentFrontInput = frontInputs.first
        currentBackInput = backInputs.first
        session.addInput(currentBackInput)
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        session.commitConfiguration()
        session.startRunning()
        vcDelegate?.cameraDidFinishSetup()
    }
}
