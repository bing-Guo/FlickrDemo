import Foundation
import RealmSwift

class FavoriteManager {
    static let sharedInstance = FavoriteManager()
    
    private init() {}
    
    func insertPhotoToFavorite(photo: PhotoListViewModel) {
        let realm = try! Realm()
        
        let photoRealm = PhotoRealm()
        photoRealm.configure(photo: photo)
        
        try! realm.write {
            realm.add(photoRealm)
        }
    }
    
    func removePhotoFromFavorite(id: String) {
        let realm = try! Realm()
        
        let result = realm.objects(PhotoRealm.self).filter({ $0.id == id })
        
        try! realm.write {
            realm.delete(result)
        }
    }
    
    func isExistedInFavorite(id: String) -> Bool {
        let realm = try! Realm()
        
        let result = realm.objects(PhotoRealm.self).filter({ $0.id == id })
        
        return (result.count > 0)
    }
}
