import UIKit
import AVFoundation
import Photos
import PhotosUI

extension CameraManager: AVCapturePhotoCaptureDelegate {
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
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
                                print("change image")
                                self.UIDelegate?.updatePreviewImage()
                            }
                            
                        }
                    } catch let error {
                        print("failed to save photo in library: ", error)
                    }
                } else {
                }
            }
        }
    }
    
    func isFlashAvailable() -> AVCaptureDevice.FlashMode? {
        for mode in photoOutput.supportedFlashModes {
            if flashMode == mode {
                return flashMode
            }
        }
        return nil
    }
    
    @objc func takePhoto() {
        requestCaptureAccess { granted in
            if granted {
                let photoSettings = AVCapturePhotoSettings()
                if let flashMode = self.isFlashAvailable() {
                    photoSettings.flashMode = flashMode
                } else {
                    photoSettings.flashMode = .off
                }
                if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                    photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
                    self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
                }
            }
        }
    }
}
