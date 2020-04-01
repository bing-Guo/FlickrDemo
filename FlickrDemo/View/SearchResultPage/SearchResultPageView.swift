import UIKit
import RealmSwift

protocol SearchResultPageDelegate: NSObject {
    func endOfScrolling()
}

class SearchResultPageView: UIView {
    private var collectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    private let cellTemplate = PictureCell()
    weak var delegate: SearchResultPageDelegate?
    let activityView = UIActivityIndicatorView(style: .large)
    let favoriteManager = FavoriteManager.sharedInstance
    var noDataLabel: UILabel?
    var photos: [PhotoListViewModel] = []
    
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        super.init(frame: .zero)
        
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.reuseIdentifier)
       
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 414, height: 20 ))
        noDataLabel?.textAlignment = .center
        noDataLabel?.isHidden = true
        
        collectionView.addSubview(noDataLabel!)
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.pin.vertically().horizontally(pin.safeArea)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.center = collectionView.center
        activityView.startAnimating()
        
        addSubview(activityView)
    }
    
    // MARK: - Action
    
    func insertPhoto(photos: [PhotoListViewModel]) {
        noDataLabel?.isHidden = true
        
        let start = self.photos.count
        self.photos += photos
        let end = self.photos.count
        
        collectionView.performBatchUpdates( {() -> Void in
            let insertIndexPaths = Array(start..<end).map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: insertIndexPaths)
            stopActivityAnimating()
        }, completion: nil)
    }
    
    func resetPhoto(photos: [PhotoListViewModel]) {
        noDataLabel?.isHidden = true
        self.photos = photos
        collectionView.reloadData()
        stopActivityAnimating()
    }
    
    func stopActivityAnimating() {
        self.activityView.stopAnimating()
    }
    
    func setEmptyDataInfo(text: String) {
        noDataLabel?.isHidden = false
        noDataLabel?.text = text
        self.stopActivityAnimating()
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension SearchResultPageView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseIdentifier, for: indexPath) as! PictureCell
        cell.configure(photo: photos[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellTemplate.configure(photo: photos[indexPath.row])
        return cellTemplate.sizeThatFits(CGSize(width: (collectionView.bounds.width-30)/2, height: .greatestFiniteMagnitude))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == photos.count - 1 ) {
            delegate?.endOfScrolling()
        }
    }
}

// MARK: - PictureCellDelegate

extension SearchResultPageView: PictureCellDelegate {
    func likeButtonTapped(photo: PhotoListViewModel, button: UIButton) {
        if favoriteManager.isExistedInFavorite(id: photo.id) {
            favoriteManager.removePhotoFromFavorite(id: photo.id)
            button.depopulateLikeButton()
        } else {
            favoriteManager.insertPhotoToFavorite(photo: photo)
            button.populateLikeButton()
        }
    }
}
