import UIKit
import AVFoundation
import Photos
import PhotosUI

extension CameraManager: AVCapturePhotoCaptureDelegate {
    @objc func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        switch self.flashMode {
            case .auto:
                photoSettings.flashMode = .auto
            case .on:
                photoSettings.flashMode = .on
            case .off:
                photoSettings.flashMode = .off
        }
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        if let image = UIImage(data: imageData) {
            var processedImage = image
            switch UIDevice.current.orientation {
                case .unknown:
                    break
                case .portrait:
                    break
                case .portraitUpsideDown:
                    processedImage = processedImage.rotate(radians: .pi)!
                case .landscapeLeft:
                    processedImage = processedImage.rotate(radians: .pi*1.5)!
                case .landscapeRight:
                    processedImage = processedImage.rotate(radians: .pi/2)!
                case .faceUp:
                    break
                case .faceDown:
                    break
                @unknown default:
                    break
            }
            requestLibraryAccess { granted in
                if granted {
                    do {
                        try PHPhotoLibrary.shared().performChangesAndWait {
                            PHAssetChangeRequest.creationRequestForAsset(from: processedImage)
                            print("photo has saved in library...")
                            DispatchQueue.main.async {
                                self.vcDelegate?.cameraDidSavePhoto(image: image)
                            }
                        }
                    } catch let error {
                        print("failed to save photo in library: ", error)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.vcDelegate?.showAlert(title: "Unable to save photo", msg: "Please provide access to the gallery in the device settings and try again", actions: [UIAlertAction(title: "OK", style: .cancel)])
                    }
                }
            }
        }
    }
}
