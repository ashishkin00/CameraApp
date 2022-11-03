import UIKit
import Photos
import PhotosUI

class CameraUI: UIView {
    let previewView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .green
        return view
    }()
    
    let previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.videoGravity = .resizeAspect
        return layer
    }()
    
    let aspectRatioButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "aspectratio.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let flashButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        button.tintColor = .white
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
        return button
    }()
    
    let previewImage: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentMode = .center
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat(30)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setImage(UIImage(systemName: "person"), for: .normal)
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
        return view
    }()
    
    let settingsView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let quickSettingsStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.backgroundColor = .gray.withAlphaComponent(0.25)
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
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        
//        quickSettingsStackView.addArrangedSubview()
//        moduleButton.translatesAutпoresizingMaskIntoConstraints = false
        
        quickSettingsStackView.addArrangedSubview(aspectRatioButton)
        aspectRatioButton.translatesAutoresizingMaskIntoConstraints = false
            
        quickSettingsStackView.addArrangedSubview(UIView(frame: .zero))
    }
    
    func setup() {
        addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(previewImage)
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(positionButton)
        positionButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(recordInformation)
        recordInformation.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(settingsView)
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            settingsView.topAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsView.leadingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            settingsView.trailingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingsView.bottomAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            quickSettingsStackView.topAnchor.constraint(equalTo: previewView.bottomAnchor),
            quickSettingsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            quickSettingsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            quickSettingsStackView.bottomAnchor.constraint(equalTo: photoButton.topAnchor, constant: -5),
            
            //            previewImage.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor),
            //            previewImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25),
            //            previewImage.heightAnchor.constraint(equalToConstant: 75),
            //            previewImage.widthAnchor.constraint(equalToConstant: 75),
            //
            //            flashButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            //            flashButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            //            flashButton.widthAnchor.constraint(equalToConstant: 35),
            //            flashButton.heightAnchor.constraint(equalToConstant: 35),
            //
            //            positionButton.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor),
            //            positionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25),
            //            positionButton.heightAnchor.constraint(equalToConstant: 75),
            //            positionButton.widthAnchor.constraint(equalToConstant: 75),
            //
            //            moduleButton.centerYAnchor.constraint(equalTo: flashButton.centerYAnchor),
            //            moduleButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25),
            //            moduleButton.heightAnchor.constraint(equalToConstant: 35),
            //            moduleButton.widthAnchor.constraint(equalToConstant: 35),
            //
            //            recordButton.bottomAnchor.constraint(equalTo: photoButton.bottomAnchor),
            //            recordButton.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor),
            //            recordButton.heightAnchor.constraint(equalToConstant: 50),
            //            recordButton.widthAnchor.constraint(equalToConstant: 50),
            //
            //            recordInformation.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor),
            //            recordInformation.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            //            recordInformation.trailingAnchor.constraint(equalTo: photoButton.leadingAnchor),
            
            
        ])
    }
}


