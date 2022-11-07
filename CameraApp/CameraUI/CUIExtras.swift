import UIKit
import Photos

extension CameraUI {
    // IMPLEMENT DEGREES TO RADIANS CONVERTER
    func rotateUI() {
        UIView.animate(withDuration: 0.5) {
            switch UIDevice.current.orientation {
                case .unknown:
                    break
                case .portrait:
                    self.previewImage.transform = CGAffineTransform(rotationAngle: .pi*2)
                    self.flashButton.transform = CGAffineTransform(rotationAngle: .pi*2)
                    self.moduleButton.transform = CGAffineTransform(rotationAngle: .pi*2)
                case .portraitUpsideDown:
                    break
                case .landscapeLeft:
                    self.previewImage.transform = CGAffineTransform(rotationAngle: .pi/2)
                    self.flashButton.transform = CGAffineTransform(rotationAngle: .pi/2)
                    self.moduleButton.transform = CGAffineTransform(rotationAngle: .pi/2)
                case .landscapeRight:
                    self.previewImage.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                    self.flashButton.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                    self.moduleButton.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                case .faceUp:
                    break
                case .faceDown:
                    break
                @unknown default:
                    break
            }
        }
    }
    
    func updatePreviewImage() {
        fetchLastPhotoFromGallery()
    }
    
    func fetchLastPhotoFromGallery() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            PHImageManager.default().requestImage(for: fetchResult.firstObject! as PHAsset, targetSize: CGSize(width: 256, height: 256), contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, info) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.previewImage.setImage(image, for: .normal)
                    }
                }
            })
        }
    }
}
