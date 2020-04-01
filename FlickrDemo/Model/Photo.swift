import Foundation

struct Photo: Decodable {
    let farm: Int
    let secret: String
    let id: String
    let server: String
    let title: String
}

struct PhotoData: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]
}

struct SearchData: Decodable {
    let photos: PhotoData
    let stat: String
}
