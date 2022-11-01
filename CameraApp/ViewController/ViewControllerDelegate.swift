import UIKit

protocol ViewControllerDelegate: AnyObject {
    func cameraDidFinishSetup()
    func showAlert(title: String, msg: String, actions: [UIAlertAction])
    func refreshPreviewImage()
    func cameraDidSavePhoto(image: UIImage)
}

extension ViewController: ViewControllerDelegate {
    func showAlert(title: String, msg: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        for x in actions {
            alert.addAction(x)
        }
        present(alert, animated: true)
    }
    
    func cameraDidFinishSetup() {
        DispatchQueue.main.async {
            self.setup()
        }
    }
    
    func cameraDidSavePhoto(image: UIImage) {
        ui.previewImage.image = image
    }
    
    func refreshPreviewImage() {
        getLastPhotoFromGallery()
    }
}
