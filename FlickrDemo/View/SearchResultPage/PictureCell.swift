import UIKit
import FlexLayout
import PinLayout

protocol PictureCellDelegate: NSObject {
    func likeButtonTapped(photo: PhotoListViewModel, button: UIButton)
}

class PictureCell: UICollectionViewCell {
    static let reuseIdentifier = "PictureCell"
    weak var delegate: PictureCellDelegate?
    let titleLabel: UILabel = UILabel()
    let imageView: UIImageView = UIImageView()
    let likeButton: UIButton = UIButton()
    var photo: PhotoListViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textAlignment = .left
        
        likeButton.depopulateLikeButton()
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        contentView.flex.direction(.column).define { (flex) in
            
            flex.addItem(imageView).height(190)
            
            flex.addItem().direction(.row).paddingTop(5).define{ (flex) in
                flex.addItem(likeButton).top(5).width(25).height(20).position(.absolute)
                flex.addItem(titleLabel).marginLeft(35)
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
    
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    // MARK: - Action
    
    func configure(photo: PhotoListViewModel) {
         self.photo = photo
         
         titleLabel.text = photo.title
         photo.like ? likeButton.populateLikeButton() : likeButton.depopulateLikeButton()
         self.imageView.setImage(url: photo.url)
    
         setNeedsLayout()
     }
    
    @objc func likeTapped(sender: UIButton) {
        if let photo = self.photo {
            self.delegate?.likeButtonTapped(photo: photo, button: sender)
        }
    }

}

