import UIKit
import AVFoundation
import Photos
import PhotosUI

class ViewController: UIViewController {
    let camera = CameraManager()
    let cameraUI = CameraUI()
    let notification = NotificationCenter.default
   
    override func viewDidLoad() {
        super.viewDidLoad()
        camera.setup()
        camera.UIDelegate = cameraUI
        cameraUI.setViewFrameSize(size: view.frame.size)
        cameraUI.setPreviewLayerSession(session: camera.session, frame: view.frame)
        view.addSubview(cameraUI)
        cameraUI.photoButton.addTarget(camera, action: #selector(camera.takePhoto), for: .touchUpInside)
        cameraUI.recordButton.addTarget(camera, action: #selector(camera.recordVideo), for: .touchUpInside)
        cameraUI.flashButton.addTarget(camera, action: #selector(camera.setNextFlashMode), for: .touchUpInside)
        cameraUI.previewImage.addTarget(self, action: #selector(share), for: .touchUpInside)
        cameraUI.positionButton.addTarget(camera, action: #selector(camera.changeCameraPosition), for: .touchUpInside)
        //cameraUI.photoButton.addTarget(camera, action: #selector(camera.recordVideo), for: .touchDown)
        
        let zoomGesture = UIPinchGestureRecognizer(target: camera, action: #selector(camera.zoom(_:)))
        cameraUI.addGestureRecognizer(zoomGesture)
        
        notification.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
            self.cameraUI.fetchLastPhotoFromGallery()
        }
        
    }
    
    @objc func share() {
        let gallery = GalleryViewController()
        gallery.modalPresentationStyle = .automatic
        present(gallery, animated: true, completion: nil)
    }
}

