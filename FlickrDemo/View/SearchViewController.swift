import UIKit

class SearchViewController: UIViewController {
    private var mainView: SearchPageView {
        return view as! SearchPageView
    }
    var keyword: String?
    var perPage: String?
    
    override func loadView() {
        let view = SearchPageView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "搜尋輸入頁"
    }
    
    func validateForm() -> Bool{
        guard !keyword.isNilOrEmpty && !perPage.isNilOrEmpty else {
            return false
        }
        return true
    }
    
    func setButtonStatusByValidateResult(validateResult: Bool) {
        if validateResult {
            self.mainView.setButtonEnable()
        } else {
            self.mainView.setButtonDisable()
        }
    }
}

extension SearchViewController: SearchPageDelegate {
    func getKeywordTextField(field: UITextField) {
        if let text = field.text {
            keyword = text
            let result = validateForm()
            setButtonStatusByValidateResult(validateResult: result)
        }
    }
    
    func getPerPageTextField(field: UITextField) {
        if let text = field.text {
            perPage = text
            let result = validateForm()
            setButtonStatusByValidateResult(validateResult: result)
        }
    }
    
    func submitForm() {
        let vc = SearchResultViewController()
        vc.configure(keyword: keyword!, perPage: perPage!)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
