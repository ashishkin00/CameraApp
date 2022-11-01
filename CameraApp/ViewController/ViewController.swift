import UIKit
import AVFoundation
import Photos
import PhotosUI

class ViewController: UIViewController {
    private let camera = CameraManager()
    let ui = CameraUI()
    private let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera.vcDelegate = self
        camera.uiDelegate = ui
        camera.start()
    }
    
    @objc func openGallery() {
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    @objc func getLastPhotoFromGallery() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            PHImageManager.default().requestImage(for: fetchResult.firstObject! as PHAsset, targetSize: CGSize(width: 256, height: 256), contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.ui.previewImage.image = image
                    }
                }
            })
        }
    }
    
    @objc func orientationDidChange() {
        ui.rotateUI()
    }
    
    func setup() {
        camera.previewLayer.frame = view.frame
        camera.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.previewLayer)
        
        ui.frame = view.frame
        view.addSubview(ui)
        
        notificationCenter.addObserver(self, selector: #selector(getLastPhotoFromGallery), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        let zoomGesture = UIPinchGestureRecognizer(target: camera, action: #selector(camera.zoom(_:)))
        view.addGestureRecognizer(zoomGesture)
        
        let previewImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        ui.previewImage.isUserInteractionEnabled = true
        ui.previewImage.addGestureRecognizer(previewImageTapGesture)
        
        
        ui.shutterButton.addTarget(camera, action: #selector(camera.takePhoto), for: .touchUpInside)
        
        let moduleSwitchButtonTapGesture = UITapGestureRecognizer(target: camera, action: #selector(camera.switchCameraModule))
        ui.moduleSwitchButton.isUserInteractionEnabled = true
        ui.moduleSwitchButton.addGestureRecognizer(moduleSwitchButtonTapGesture)
        
        ui.cameraSwitcherButton.isUserInteractionEnabled = true
        let cameraSwitcherButtonTapGesture = UITapGestureRecognizer(target: camera, action: #selector(camera.switchCameraPosition))
        ui.cameraSwitcherButton.addGestureRecognizer(cameraSwitcherButtonTapGesture)
        
        ui.flashButton.addTarget(camera, action: #selector(camera.setNextFlashMode), for: .touchUpInside)
        ui.flashButton.setBackgroundImage(UIImage(systemName: camera.flashMode.rawValue), for: .normal)
        
        ui.recordButton.isUserInteractionEnabled = true
        ui.recordButton.addTarget(camera, action: #selector(camera.toggleRecord), for: .touchUpInside)
    }
}

