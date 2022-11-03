import UIKit
import AVFoundation
import Photos
import PhotosUI

class ViewController: UIViewController {
    let camera = CameraManager()
    let cameraUI = CameraUI()
    override func viewDidLoad() {
        super.viewDidLoad()
        camera.setup()
        cameraUI.setViewFrameSize(size: view.frame.size)
        cameraUI.setPreviewLayerSession(session: camera.session, frame: view.frame)
        view.addSubview(cameraUI)
        cameraUI.photoButton.addTarget(camera, action: #selector(camera.takePhoto), for: .touchUpInside)
        cameraUI.recordButton.addTarget(camera, action: #selector(camera.recordVideo), for: .touchUpInside)
        
        let zoomGesture = UIPinchGestureRecognizer(target: camera, action: #selector(camera.zoom(_:)))
        cameraUI.addGestureRecognizer(zoomGesture)
    }
}

