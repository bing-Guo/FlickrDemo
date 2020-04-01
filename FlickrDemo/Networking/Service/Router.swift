import Foundation

class Router<EndPoint: EndPointType> {
    private var task: URLSessionTask?
    public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        task = session.dataTask(with: route.url, completionHandler: { data, response, error in
            completion(data, response, error)
        })
        self.task?.resume()
    }
}
