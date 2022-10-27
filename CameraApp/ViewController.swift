import UIKit
import AVFoundation
import Photos
import PhotosUI

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    private let photoOutput = AVCapturePhotoOutput()
    private let notificationCenter = NotificationCenter.default
    private lazy var flashMode: FlashModes = .auto
    private lazy var zoomFactor: CGFloat = 1
    private let captureSession = AVCaptureSession()
    private var backCamera : AVCaptureDevice!
    private var backInput : AVCaptureInput!
    private var frontCamera : AVCaptureDevice!
    private var frontInput : AVCaptureInput!
    private let movieOutput = AVCaptureMovieFileOutput()
    private lazy var currentCameraPosition: CameraPosition = .back
    private var outputURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(rotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        setupCaptureDevice()
    }
    
    @objc func switchCamera() {
        cameraSwitcher.isUserInteractionEnabled = false
        currentCameraPosition = currentCameraPosition.next()
        captureSession.beginConfiguration()
        switch currentCameraPosition {
            case .front:
                captureSession.removeInput(backInput)
                captureSession.addInput(frontInput)
            case .back:
                captureSession.removeInput(frontInput)
                captureSession.addInput(backInput)
        }
        captureSession.commitConfiguration()
        cameraSwitcher.isUserInteractionEnabled = true
    }
    
    @objc func rotate() {
        let device = UIDevice.current
        UIView.animate(withDuration: 0.5) {
            switch device.orientation {
                case .unknown:
                    break
                case .portrait:
                    previewImage.transform = CGAffineTransform(rotationAngle: .pi*2)
                    torch.transform = CGAffineTransform(rotationAngle: .pi*2)
                case .portraitUpsideDown:
                    break
                case .landscapeLeft:
                    previewImage.transform = CGAffineTransform(rotationAngle: .pi/2)
                    torch.transform = CGAffineTransform(rotationAngle: .pi/2)
                case .landscapeRight:
                    previewImage.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                    torch.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                case .faceUp:
                    break
                case .faceDown:
                    break
                @unknown default:
                    break
            }
        }
    }
    
    @objc func applicationWillEnterForeground() {
        debugPrint("Application will enter foreground")
        getLastPhotoFromGallery()
    }
    
    func setupCaptureDevice() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupCaptureSession()
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.setupCaptureSession()
                        }
                    } else {
                        self.dismiss(animated: true)
                    }
                })
            case .restricted:
                print("Restricted")
                self.dismiss(animated: true)
            case .denied:
                print("Denied")
                self.dismiss(animated: true)
            @unknown default:
                print("def")
                self.dismiss(animated: true)
        }
    }
    
    func setupCaptureSession() {
        captureSession.beginConfiguration()
        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = captureDevice
            do {
                backInput = try AVCaptureDeviceInput(device: backCamera)
                if captureSession.canAddInput(backInput) {
                    captureSession.addInput(backInput)
                }
            } catch let error {
                print("Caught an exception while creating capture device: \(error)")
            }
        }
        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = captureDevice
            do {
                frontInput = try AVCaptureDeviceInput(device: frontCamera)
                if captureSession.canAddInput(frontInput) {
                    captureSession.addInput(frontInput)
                }
            } catch let error {
                print("Caught an exception while creating capture device: \(error)")
            }
        }
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.frame = self.view.frame
        cameraLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(cameraLayer)
        captureSession.commitConfiguration()
        captureSession.startRunning()
        setupUI()
    }
    
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        lazy var temp: CGFloat = 0
        if gesture.state == .changed {
            zoomFactor += (gesture.velocity - 0.5) / 25
            zoomFactor = zoomFactor.clamped(1, 10)
            if let captureDevice = AVCaptureDevice.default(for: .video) {
                do {
                    try captureDevice.lockForConfiguration()
                } catch {
                    
                }
                captureDevice.videoZoomFactor = zoomFactor
                captureDevice.unlockForConfiguration()
            }
        }
    }
    
    func setupUI() {
        view.addSubview(shutter)
        view.addSubview(previewImage)
        view.addSubview(cameraSwitcher)
        view.addSubview(torch)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        let tapGestureSwitcher = UITapGestureRecognizer(target: self, action: #selector(switchCamera))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        
        shutter.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        torch.addTarget(self, action: #selector(setNextFlashMode), for: .touchUpInside)
        
        shutter.translatesAutoresizingMaskIntoConstraints = false
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        torch.translatesAutoresizingMaskIntoConstraints = false
        cameraSwitcher.translatesAutoresizingMaskIntoConstraints = false
        
        previewImage.isUserInteractionEnabled = true
        cameraSwitcher.isUserInteractionEnabled = true
        previewImage.addGestureRecognizer(tapGesture)
        cameraSwitcher.addGestureRecognizer(tapGestureSwitcher)
        view.addGestureRecognizer(pinchGesture)
        
        torch.setBackgroundImage(UIImage(systemName: flashMode.rawValue), for: .normal)
        
        NSLayoutConstraint.activate([
            shutter.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            shutter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            shutter.heightAnchor.constraint(equalToConstant: 100),
            shutter.widthAnchor.constraint(equalToConstant: 100),
            
            previewImage.centerYAnchor.constraint(equalTo: shutter.centerYAnchor),
            previewImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            previewImage.heightAnchor.constraint(equalToConstant: 75),
            previewImage.widthAnchor.constraint(equalToConstant: 75),
            
            torch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            torch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            torch.widthAnchor.constraint(equalToConstant: 35),
            torch.heightAnchor.constraint(equalToConstant: 35),
            
            cameraSwitcher.centerYAnchor.constraint(equalTo: shutter.centerYAnchor),
            cameraSwitcher.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            cameraSwitcher.heightAnchor.constraint(equalToConstant: 75),
            cameraSwitcher.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    @objc func openGallery() {
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    func getLastPhotoFromGallery() {
        print("working")
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            PHImageManager.default().requestImage(for: fetchResult.firstObject! as PHAsset, targetSize: CGSize(width: 256, height: 256), contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                if let image = image {
                    
                    previewImage.image = image
                }
            })
        }
    }
    
    @objc func setNextFlashMode() {
        flashMode = flashMode.next()
        torch.setBackgroundImage(UIImage(systemName: flashMode.rawValue), for: .normal)
    }
    
    @objc private func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        switch flashMode {
            case .auto:
                photoSettings.flashMode = .auto
            case .on:
                photoSettings.flashMode = .on
            case .off:
                photoSettings.flashMode = .off
        }
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let device = UIDevice.current
        guard let imageData = photo.fileDataRepresentation() else { return }
        var image = UIImage(data: imageData)
        switch device.orientation {
            case .unknown:
                break
            case .portrait:
                break
            case .portraitUpsideDown:
                image = image?.rotate(radians: .pi)
            case .landscapeLeft:
                image = image?.rotate(radians: .pi*1.5)
            case .landscapeRight:
                image = image?.rotate(radians: .pi/2)
            case .faceUp:
                break
            case .faceDown:
                break
            @unknown default:
                break
        }
        previewImage.image = image
        savePhoto()
    }
    
    func savePhoto() {
        guard let previewImage = previewImage.image else { return }
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                        print("photo has saved in library...")
                    }
                } catch let error {
                    print("failed to save photo in library: ", error)
                }
            } else {
                print("Something went wrong with permission...")
            }
        }
    }
}

