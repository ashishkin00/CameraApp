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
                        }
                    } catch let error {
                        print("failed to save photo in library: ", error)
                    }
                } else {
                }
            }
        }
    }
    
    @objc func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = flashMode
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
}
