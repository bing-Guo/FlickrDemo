import UIKit

class SearchResultViewController: UIViewController {
    private var keyword: String?
    private var perPage: String?
    private var page: Int = 1
    private var networkManager = NetworkManager()
    
    private var mainView: SearchResultPageView {
        return view as! SearchResultPageView
    }
    
    override func loadView() {
        let view = SearchResultPageView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "搜尋結果 \(keyword ?? "")"
        fetchData()
    }
    
    func configure(keyword: String, perPage: String) {
        self.keyword = keyword
        self.perPage = perPage
    }
    
    func fetchData() {
        DispatchQueue.global(qos: .background).async {
            self.networkManager.getFlickrPhoto(keyword: self.keyword!, perPage: Int(self.perPage!)!, page: self.page) { data, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.mainView.setEmptyDataInfo(text: error)
                        return
                    }
                    
                    if let data = data {
                        var photos = [PhotoListViewModel]()
                        photos = data.map( { PhotoListViewModel(photo: $0) } )
                        self.mainView.insertPhoto(photos: photos)
                    }
                }
            }
        }
    }
}

extension SearchResultViewController: SearchResultPageDelegate {
    func endOfScrolling() {
        self.page += 1
        fetchData()
    }
}

