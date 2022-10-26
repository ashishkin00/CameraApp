import UIKit

let torch: UIButton = {
    let button = UIButton(frame: .zero)
    button.tintColor = .white
    button.contentMode = .scaleAspectFill
    return button
}()

let shutter: UIButton = {
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

//let recordButton: UIButton = {
//    let size = 50
//    let button = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
//    button.layer.cornerRadius = CGFloat(size / 2)
//    button.layer.backgroundColor = UIColor.red.cgColor
//    button.contentMode = .scaleAspectFill
//    button.layer.borderWidth = 5
//    button.layer.borderColor = UIColor.black.cgColor
//    return button
//}()

let previewImage: UIImageView = {
    let size = 75
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
    imageView.layer.cornerRadius = CGFloat(size / 2)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .red
    return imageView
}()

let cameraSwitcher: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(systemName: "arrow.2.circlepath")
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.tintColor = .white
    return imageView
}()
