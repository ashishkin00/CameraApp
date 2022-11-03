import Foundation
import UIKit
import AVFoundation

extension CameraManager {
    @objc func zoom(_ gesture: UIPinchGestureRecognizer) {
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                try captureDevice.lockForConfiguration()
                switch gesture.state {
                    case .began:
                        zoomFactor = captureDevice.videoZoomFactor
                    case .changed:
                        var factor = zoomFactor * gesture.scale
                        factor = max(1, min(factor, captureDevice.activeFormat.videoMaxZoomFactor))
                        captureDevice.videoZoomFactor = factor
                    default:
                        break
                }
                captureDevice.unlockForConfiguration()
            } catch {
                
            }
        }
    }
}
