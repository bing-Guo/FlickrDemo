import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {
    private var mainView: SearchResultPageView {
        return view as! SearchResultPageView
    }
    
    override func loadView() {
        let view = SearchResultPageView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的最愛"
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func fetchData() {
        DispatchQueue.global(qos: .background).async {
            let realm = try! Realm()
            let photosFromRealm = realm.objects(PhotoRealm.self)
            var photos = [PhotoListViewModel]()
            photos = photosFromRealm.map( { PhotoListViewModel(photo: $0) } )

            DispatchQueue.main.async {
                self.mainView.resetPhoto(photos: photos)
                if photos.count == 0{
                    self.mainView.setEmptyDataInfo(text: "尚未有收藏")
                }
            }
        }
    }
}
