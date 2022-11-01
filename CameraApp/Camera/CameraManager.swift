import UIKit
import AVFoundation
import Photos
import PhotosUI

class CameraManager: NSObject {
    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureMovieFileOutput()
    
    var currentCameraDevice: AVCaptureDeviceInput!
    var currentMicrophone: AVCaptureDeviceInput!
    lazy var frontInputs: [AVCaptureDeviceInput] = []
    lazy var backInputs: [AVCaptureDeviceInput] = []
    lazy var mic: [AVCaptureDeviceInput] = []
    
    lazy var previewLayer = AVCaptureVideoPreviewLayer()
    lazy var zoomFactor: CGFloat = 1
    
    lazy var position: CameraPosition = .back
    lazy var flashMode: FlashModes = .auto
    
    weak var vcDelegate: ViewControllerDelegate?
    weak var uiDelegate: CameraUIDelegate?
    
    func start() {
        DispatchQueue.main.async {
            self.setupDevices()
        }
    }
    
    func addCaptureDeviceInputs(devices: AVCaptureDevice.DiscoverySession) {
        for device in devices.devices {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                switch input.device.position {
                    case .unspecified:
                        currentMicrophone = input
                    case .back:
                        backInputs.append(input)
                    case .front:
                        frontInputs.append(input)
                    @unknown default:
                        break
                }
            } catch let error {
                print("Unable to fetch capture device input: \(error)")
            }
        }
    }
    
    func addCaptureOutput(outputs: [AVCaptureOutput]) {
        for output in outputs {
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
        }
    }
    
    func defineDefaultInputs() {
        switch position {
            case .front:
                if frontInputs.count != 0 {
                    currentCameraDevice = frontInputs.first
                }
            case .back:
                if backInputs.count != 0 {
                    currentCameraDevice = backInputs.first
                }
        }
        if session.canAddInput(currentCameraDevice) {
            session.addInput(currentCameraDevice)
        } else {
            print("Unable to add capture device input")
        }
    }
    
    func setupDevices() {
        session.beginConfiguration()
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera], mediaType: .video, position: .unspecified)
        addCaptureDeviceInputs(devices: devices)
        defineDefaultInputs()
        addCaptureOutput(outputs: [photoOutput, videoOutput])
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        session.commitConfiguration()
        session.startRunning()
        vcDelegate?.cameraDidFinishSetup()
    }
}
