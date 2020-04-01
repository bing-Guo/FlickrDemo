import Foundation
import UIKit

extension UIButton {
    func populateLikeButton() {
        let likeImage = UIImage(systemName: "heart.fill")
        self.setBackgroundImage(likeImage, for: .normal)
        self.tintColor = .red
    }
    
    func depopulateLikeButton() {
        let likeImage = UIImage(systemName: "heart")
        self.setBackgroundImage(likeImage, for: .normal)
        self.tintColor = .black
    }
}
