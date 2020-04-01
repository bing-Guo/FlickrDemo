import Foundation

class FlickrAPI: EndPointType {
    private var apiKey = "a6cfd97e203b98bf7d87cf8f4778b31b"
    private var keyword: String
    private var perPage: Int
    private var page: Int = 1
    var url: URL
    
    init(keyword: String, perPage: Int, page: Int) {
        self.keyword = keyword
        self.perPage = perPage
        self.page = page
        
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(self.apiKey)&text=\(keyword)&per_page=\(perPage)&page=\(page)&format=json&nojsoncallback=1"
        let urlEncodingString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlEncoding = urlEncodingString, let url = URL(string: urlEncoding) else { fatalError("baseURL could not be configured.") }
        
        self.url = url
    }
}
