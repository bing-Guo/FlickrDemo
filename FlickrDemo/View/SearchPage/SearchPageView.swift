import UIKit
import FlexLayout
import PinLayout

protocol SearchPageDelegate: NSObject {
    func getKeywordTextField(field: UITextField)
    func getPerPageTextField(field: UITextField)
    func submitForm()
}

class SearchPageView: UIView {
    private let rootFlexContainer = UIView()
    private let keywordTextField = UITextField()
    private let perPageTextField = UITextField()
    private let submitButton = UIButton()
    private let perPageToolBar = UIToolbar()
    weak var delegate: SearchPageDelegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupKeywordTextField()
        setupPerPageTextField()
        setupButton()
        
        rootFlexContainer.flex.justifyContent(.center).padding(UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)).define { (flex) in
            flex.addItem().direction(.column).define { (flex) in
                flex.addItem(keywordTextField)
                flex.addItem(perPageTextField).marginTop(24)
                flex.addItem(submitButton).marginTop(24)
            }
        }
        
        addSubview(rootFlexContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    func setupKeywordTextField() {
        keywordTextField.delegate = self
        keywordTextField.placeholder = "欲搜尋內容"
        keywordTextField.layer.cornerRadius = 8
        keywordTextField.clearButtonMode = .whileEditing
        keywordTextField.borderStyle = .roundedRect
        keywordTextField.returnKeyType = .done
        keywordTextField.tag = 0
        keywordTextField.addTarget(self, action: #selector(keywordTextFieldChange), for: .editingChanged)
    }
    
    func setupPerPageTextField() {
        perPageTextField.delegate = self
        perPageTextField.placeholder = "每頁呈現數量"
        perPageTextField.layer.cornerRadius = 8
        perPageTextField.clearButtonMode = .whileEditing
        perPageTextField.borderStyle = .roundedRect
        perPageTextField.keyboardType = .decimalPad
        perPageTextField.tag = 1
        perPageTextField.addTarget(self, action: #selector(perPageTextFieldChange), for: .editingChanged)
        
        setPerPageToolBar()
        perPageTextField.inputAccessoryView = perPageToolBar
    }
    
    func setPerPageToolBar() {
        perPageToolBar.items=[
            UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(tapPerPageCancelButton)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(tapPerPageCompleteButton))
        ]

        perPageToolBar.sizeToFit()
    }
    
    func setupButton() {
        submitButton.setTitle("搜尋", for: .normal)
        submitButton.backgroundColor = .gray
        submitButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        setButtonDisable()
    }
    
    func setButtonEnable() {
        submitButton.isEnabled = true
        submitButton.backgroundColor = .blue
        
    }
    
    func setButtonDisable() {
        submitButton.isEnabled = false
        submitButton.backgroundColor = .gray
    }
    
}

// MARK: - Action

extension SearchPageView {
    
    @objc func searchAction(sender: UIButton!) {
        keywordTextField.resignFirstResponder()
        perPageTextField.resignFirstResponder()
        delegate?.submitForm()
    }
    
    @objc func keywordTextFieldChange(sender: UITextField!) {
        delegate?.getKeywordTextField(field: sender)
    }
    
    @objc func perPageTextFieldChange(sender: UITextField!) {
        delegate?.getPerPageTextField(field: sender)
    }
    
    @objc func tapPerPageCompleteButton() {
        delegate?.getPerPageTextField(field: perPageTextField)
        perPageTextField.resignFirstResponder()
    }
    
    @objc func tapPerPageCancelButton () {
        perPageTextField.resignFirstResponder()
    }
    
}

// MARK: - UITextFieldDelegate

extension SearchPageView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textField: \(textField.tag)")
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == perPageTextField {
            let allowCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
}
