import UIKit
import Photos
import PhotosUI

protocol CameraUIDelegate: AnyObject {
    func setFlashButtonImage(flashMode: AVCaptureDevice.FlashMode)
    func updatePreviewImage()
    func updatePhotoButton(isRecording: Bool)
}

class CameraUI: UIView, CameraUIDelegate {
    func updatePhotoButton(isRecording: Bool) {
        if isRecording {
            photoButton.tintColor = .red
        } else {
            photoButton.tintColor = .white
        }
        
    }
    
    func setFlashButtonImage(flashMode: AVCaptureDevice.FlashMode) {
        switch flashMode {
            case .off:
                flashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
            case .on:
                flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
            case .auto:
                flashButton.setImage(UIImage(systemName: "bolt.badge.a.fill"), for: .normal)
            @unknown default:
                break
        }
    }
    
    let previewView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.videoGravity = .resizeAspect
        return layer
    }()
    
    let flashButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let recordButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let photoButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let previewImage: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat(30)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let positionButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let moduleButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "camera.rotate.fill"), for: .normal)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    let recordInformation: UIView = {
        let view = UIView(frame: .zero)
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "largecircle.fill.circle")
        imageView.tintColor = .red
        let label = UILabel(frame: .zero)
        label.text = "REC"
        label.textColor = .white
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.shadowColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
        ])
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let quickSettingsStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setPreviewLayerSession(session: AVCaptureSession, frame: CGRect) {
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.main.async {
            self.previewLayer.frame = self.previewView.bounds
        }
    }
    
    func setViewFrameSize(size: CGSize) {
        frame.size = size
    }
    
    func setupQuickSettingsStackView() {
        addSubview(quickSettingsStackView)
        quickSettingsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        quickSettingsStackView.addArrangedSubview(UIView(frame: .zero))
        
        quickSettingsStackView.addArrangedSubview(flashButton)
        
        quickSettingsStackView.addArrangedSubview(recordButton)
        
        quickSettingsStackView.addArrangedSubview(moduleButton)
        
        quickSettingsStackView.addArrangedSubview(UIView(frame: .zero))
    }
    
    func setup() {
        addSubview(previewView)
        addSubview(photoButton)
        addSubview(previewImage)
        addSubview(positionButton)
        //addSubview(recordButton)
        //addSubview(recordInformation)
        previewView.layer.addSublayer(previewLayer)
        setupQuickSettingsStackView()
        NSLayoutConstraint.activate([
            
            previewView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70),
            previewView.bottomAnchor.constraint(equalTo: photoButton.topAnchor, constant: -50),
            previewView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            photoButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            photoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            photoButton.heightAnchor.constraint(equalToConstant: 100),
            photoButton.widthAnchor.constraint(equalToConstant: 100),
            
            positionButton.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor),
            positionButton.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor, constant: 45),
            positionButton.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor),
            positionButton.widthAnchor.constraint(equalToConstant: 60),
            positionButton.heightAnchor.constraint(equalToConstant: 60),
            
            previewImage.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor),
            previewImage.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor),
            previewImage.trailingAnchor.constraint(equalTo: photoButton.leadingAnchor, constant: -50),
            previewImage.widthAnchor.constraint(equalToConstant: 60),
            previewImage.heightAnchor.constraint(equalToConstant: 60),

            quickSettingsStackView.topAnchor.constraint(equalTo: previewView.bottomAnchor),
            quickSettingsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            quickSettingsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            quickSettingsStackView.bottomAnchor.constraint(equalTo: photoButton.topAnchor, constant: -5),
        ])
    }
}


