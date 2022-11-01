import Foundation
import UIKit
import AVFoundation

extension CameraManager {
    @objc func setNextFlashMode() {
        flashMode = flashMode.next()
        uiDelegate?.changeFlashIcon(flashMode: flashMode)
    }
    
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
    
    @objc func switchCameraModule() {
//        session.beginConfiguration()
//        switch position {
//            case .front:
//                if frontInputs.count > 1 {
//                    session.removeInput(currentFrontInput)
//                    currentFrontInput = frontInputs.nextItem(after: currentFrontInput)
//                    session.addInput(currentFrontInput)
//                }
//            case .back:
//                if backInputs.count > 1 {
//                    session.removeInput(currentBackInput)
//                    currentBackInput = backInputs.nextItem(after: currentBackInput)
//                    session.addInput(currentBackInput)
//                }
//        }
//        session.commitConfiguration()
    }
    
    @objc func switchCameraPosition() {
//        position = position.next()
//        session.beginConfiguration()
//        switch position {
//            case .front:
//                session.removeInput(currentBackInput)
//                session.addInput(currentFrontInput)
//            case .back:
//                session.removeInput(currentFrontInput)
//                session.addInput(currentBackInput)
//        }
//        session.commitConfiguration()
    }
}
