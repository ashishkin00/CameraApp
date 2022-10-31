import UIKit
import Photos
import PhotosUI

protocol CameraUIDelegate: AnyObject {
    func changeFlashIcon(flashMode: FlashModes)
    func hideUI(isRecording: Bool)
}

class CameraUI: UIView, CameraUIDelegate {
    func hideUI(isRecording: Bool) {
        if isRecording {
            cameraSwitcherButton.isHidden = false
            moduleSwitchButton.isHidden = false
            recordInformation.isHidden = true
        } else {
            cameraSwitcherButton.isHidden = true
            moduleSwitchButton.isHidden = true
            recordInformation.isHidden = false
        }
    }
    
    let flashButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.tintColor = .white
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let recordButton: UIButton = {
        let size = 50
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        button.layer.cornerRadius = CGFloat(size / 2)
        button.layer.backgroundColor = UIColor.red.cgColor
        button.contentMode = .scaleAspectFill
        button.layer.borderWidth = 15
        button.layer.borderColor = UIColor.darkGray.cgColor
        return button
    }()
    
    let shutterButton: UIButton = {
        let size = 100
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        button.layer.cornerRadius = CGFloat(size / 2)
        if #available(iOS 15.5, *) {
            button.layer.backgroundColor = UIColor.systemGray5.cgColor
        } else {
            button.layer.backgroundColor = UIColor.white.cgColor
        }
        button.contentMode = .scaleAspectFill
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    let previewImage: UIImageView = {
        let size = 75
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageView.layer.cornerRadius = CGFloat(size / 2)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let cameraSwitcherButton: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "arrow.2.circlepath")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()
    
    let moduleSwitchButton: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "camera.rotate.fill")
        return imageView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        addSubview(flashButton)
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(shutterButton)
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(previewImage)
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cameraSwitcherButton)
        cameraSwitcherButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(moduleSwitchButton)
        moduleSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(recordInformation)
        recordInformation.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            shutterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -25),
            shutterButton.heightAnchor.constraint(equalToConstant: 100),
            shutterButton.widthAnchor.constraint(equalToConstant: 100),
            
            previewImage.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            previewImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25),
            previewImage.heightAnchor.constraint(equalToConstant: 75),
            previewImage.widthAnchor.constraint(equalToConstant: 75),
            
            flashButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            flashButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            flashButton.widthAnchor.constraint(equalToConstant: 35),
            flashButton.heightAnchor.constraint(equalToConstant: 35),
            
            cameraSwitcherButton.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            cameraSwitcherButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25),
            cameraSwitcherButton.heightAnchor.constraint(equalToConstant: 75),
            cameraSwitcherButton.widthAnchor.constraint(equalToConstant: 75),
            
            moduleSwitchButton.centerYAnchor.constraint(equalTo: flashButton.centerYAnchor),
            moduleSwitchButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25),
            moduleSwitchButton.heightAnchor.constraint(equalToConstant: 35),
            moduleSwitchButton.widthAnchor.constraint(equalToConstant: 35),
            
            recordButton.bottomAnchor.constraint(equalTo: shutterButton.bottomAnchor),
            recordButton.leadingAnchor.constraint(equalTo: shutterButton.trailingAnchor),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            recordButton.widthAnchor.constraint(equalToConstant: 50),
            
            recordInformation.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            recordInformation.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            recordInformation.trailingAnchor.constraint(equalTo: shutterButton.leadingAnchor),
        ])
    }
    
    func changeFlashIcon(flashMode: FlashModes) {
        flashButton.setBackgroundImage(UIImage(systemName: flashMode.rawValue), for: .normal)
    }
    
    func rotateUI() {
        UIView.animate(withDuration: 0.5) {
            switch UIDevice.current.orientation {
                case .unknown:
                    break
                case .portrait:
                    self.previewImage.transform = CGAffineTransform(rotationAngle: .pi*2)
                    self.flashButton.transform = CGAffineTransform(rotationAngle: .pi*2)
                    self.moduleSwitchButton.transform = CGAffineTransform(rotationAngle: .pi*2)
                case .portraitUpsideDown:
                    break
                case .landscapeLeft:
                    self.previewImage.transform = CGAffineTransform(rotationAngle: .pi/2)
                    self.flashButton.transform = CGAffineTransform(rotationAngle: .pi/2)
                    self.moduleSwitchButton.transform = CGAffineTransform(rotationAngle: .pi/2)
                case .landscapeRight:
                    self.previewImage.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                    self.flashButton.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                    self.moduleSwitchButton.transform = CGAffineTransform(rotationAngle: .pi*1.5)
                case .faceUp:
                    break
                case .faceDown:
                    break
                @unknown default:
                    break
            }
        }
    }
}


