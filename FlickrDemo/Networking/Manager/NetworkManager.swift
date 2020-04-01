import Foundation

enum Result<String> {
    case success
    case failure(String)
}

enum NetworkResponse: String {
    case success
    case authenticationError = "權限不足"
    case badRequest = "錯誤的請求"
    case failed = "請求失敗"
    case noData = "尚未找到圖片"
    case unableToDecode = "無法解碼"
}

class NetworkManager {
    private let router = Router<FlickrAPI>()
    private var flickrAPI: FlickrAPI?
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func getFlickrPhoto(keyword: String, perPage: Int, page: Int, completion: @escaping (_ photo: [Photo]?, _ error: String?) -> ()) {
        flickrAPI = FlickrAPI(keyword: keyword, perPage: perPage, page: page)
        
        guard let flickrAPI = flickrAPI else { fatalError("FlickrAPI doesn't create.") }
        router.request(flickrAPI) { data, response, error in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else { return completion(nil, NetworkResponse.noData.rawValue) }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode(SearchData.self, from: responseData)
                        
                        if apiResponse.photos.photo.count > 0 {
                            completion(apiResponse.photos.photo, nil)
                        } else {
                            completion(nil, NetworkResponse.noData.rawValue)
                        }
                        
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
}
