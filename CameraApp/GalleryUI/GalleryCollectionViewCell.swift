import UIKit
import SnapKit


class GalleryCollectionViewCell: UICollectionViewCell {
    public static let identifier = "gallery cell"
    
    var imgPicture: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    var selectedIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "checkmark.circle")
        return imageView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        contentView.addSubview(imgPicture)
        imgPicture.addSubview(selectedIcon)

        
        imgPicture.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        (selectedIcon).snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(selectedIcon.snp.width)
        }
        
        selectedIcon.tintColor = .systemOrange
        selectedIcon.isHidden = !isSelected
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
