import Foundation
import RealmSwift

class PhotoRealm: Object {
    @objc dynamic var farm = 0
    @objc dynamic var secret = ""
    @objc dynamic var id = ""
    @objc dynamic var server = ""
    @objc dynamic var title = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func configure(photo: PhotoListViewModel) {
        self.farm = photo.farm
        self.secret = photo.secret
        self.id = photo.id
        self.server = photo.server
        self.title = photo.title
    }
}
