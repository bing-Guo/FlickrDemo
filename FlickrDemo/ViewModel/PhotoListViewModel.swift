import Foundation
import RealmSwift

class PhotoListViewModel {
    let favoriteManager = FavoriteManager.sharedInstance
    let farm: Int
    let secret: String
    let id: String
    let server: String
    let title: String
    var like: Bool
    var url: URL {
       return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
    init(farm: Int, secret: String, id: String, server: String, title: String) {
        self.farm = farm
        self.secret = secret
        self.id = id
        self.server = server
        self.title = title
        self.like = favoriteManager.isExistedInFavorite(id: id)
    }
    
    init(photo: Photo) {
        self.farm = photo.farm
        self.secret = photo.secret
        self.id = photo.id
        self.server = photo.server
        self.title = photo.title
        self.like = favoriteManager.isExistedInFavorite(id: photo.id)
    }
    
    init(photo: PhotoRealm) {
        self.farm = photo.farm
        self.secret = photo.secret
        self.id = photo.id
        self.server = photo.server
        self.title = photo.title
        self.like = true
    }
}
