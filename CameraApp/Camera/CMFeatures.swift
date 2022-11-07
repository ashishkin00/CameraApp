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
    
    @objc func changeCameraPosition() {
        print("changing camera pos")
        session.beginConfiguration()
        switch currentCameraDevice.device.position {
                
            case .unspecified:
                print("unsp")
            case .back:
                print("back")
            case .front:
                print("front")
            @unknown default:
                print("def")
        }
        if currentCameraDevice.device.position == .back {
            print("current camera pos back")
                session.removeInput(currentCameraDevice)
            currentCameraDevice = frontInputs.first!
                session.addInput(frontInputs.first!)
            
        } else if currentCameraDevice.device.position == .front {
            print("current camera pos front")
                session.removeInput(currentCameraDevice)
            currentCameraDevice = backInputs.first!
                session.addInput(backInputs.first!)
            
        }
        session.commitConfiguration()
    }
    
    func toggleTorch() {
    }
    
    @objc func setNextFlashMode() {
        switch flashMode {
            case .off:
                flashMode = .on
            case .on:
                flashMode = .auto
            case .auto:
                flashMode = .off
            @unknown default:
                break
        }
        DispatchQueue.main.async {
            self.UIDelegate?.setFlashButtonImage(flashMode: self.flashMode)
        }
    }
}
