import UIKit
import PhotosUI
import SnapKit


class GalleryViewController: UIViewController {
    var selectedImages = [UIImage]()
    var selectedIndexes = [IndexPath]()
    var allMedia = PHFetchResult<PHAsset>()
    
    var collectionView: UICollectionView =  {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    private let topPanel: UIView = {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    var shareButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.tintColor = .white
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.tintColor = .white
        button.setBackgroundImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gallery"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let collectionViewPadding = 16
    let spacingBetweenCells = 8
    let columnsNumber = 4

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(topPanel)
        view.addSubview(collectionView)
        topPanel.addSubview(backButton)
        topPanel.addSubview(titleLabel)
        topPanel.addSubview(shareButton)

        
        collectionView.allowsMultipleSelection = true
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getPhotos()
        
        setLayout()
        
        shareButton.addTarget(self, action: #selector(shareData), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapGalleryButton), for: .touchUpInside)
    }
    
    private func getPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == \(PHAssetMediaType.image.rawValue) || mediaType == \(PHAssetMediaType.video.rawValue)")
        
        allMedia = PHAsset.fetchAssets(with: fetchOptions)
        print(allMedia)
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
                
        topPanel.snp.makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
             
        shareButton.snp.makeConstraints { (make) -> Void in
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(backButton.snp.height).multipliedBy(1.1)
        }
        
        backButton.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(backButton.snp.height).multipliedBy(1.1)
        }
                
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
                        
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topPanel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    @objc func shareData() {
        let vc = UIActivityViewController(activityItems: selectedImages, applicationActivities: [])
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = shareButton.frame
        present(vc, animated: true)
      }
    
    @objc func didTapGalleryButton() {
        dismiss(animated: true, completion: nil)
    }
}


extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            @unknown default:
                fatalError("unknown status")
            }
            self.image = image
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath as IndexPath
        
        guard let cell = collectionView.cellForItem(at: index) as? GalleryCollectionViewCell else { return }
        
        cell.selectedIcon.isHidden = false

        if let image = cell.imgPicture.image {
            selectedImages.append(image)
            selectedIndexes.append(indexPath)
        }
        
        print("select item")
        print(cell.isSelected)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let index = indexPath as IndexPath
        
        guard let cell = collectionView.cellForItem(at: index) as? GalleryCollectionViewCell else { return }
        
        cell.selectedIcon.isHidden = true

        selectedImages.removeAll {
            $0 == cell.imgPicture.image
        }
        
        selectedIndexes.removeAll {
            $0 == indexPath
        }
        
        print("deselect item")
        print(cell.isSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as! GalleryCollectionViewCell
                
        cell.prepareForReuse()
        
        let asset = allMedia.object(at: indexPath.row)
        
        cell.imgPicture.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: cell.imgPicture.frame.size)

        cell.selectedIcon.isHidden = !selectedIndexes.contains(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let outterPadding = collectionViewPadding * 2
        let cellsSpacing = spacingBetweenCells * columnsNumber - 1
        let cellSize = (Int(view.bounds.width) - outterPadding - cellsSpacing) / columnsNumber
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let spacing = CGFloat(collectionViewPadding)
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingBetweenCells)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingBetweenCells)
    }
    
}
