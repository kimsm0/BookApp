/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import UIKit
import Extensions
import Combine

public class SearchView: UIView {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let containerView = UIView()
        
    private let tfContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        return view
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "검색어를 입력하세요."
        tf.borderStyle = .none
        tf.returnKeyType = .search
        tf.accessibilityIdentifier = "todo_main_textfield"
        return tf
    }()
        
    
    public init(){
        super.init(frame: .zero)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        layout()
        attribute()
    }    
    
    private func layout(){
        self.addSubview(containerView)
        tfContainerView.addSubview(textField)
        containerView.addSubview(tfContainerView)
        
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
            
            tfContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            tfContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            tfContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20),
            tfContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])          
    }
    
    private func attribute(){
        containerView.addLineShadow(location: .top)
        textField.delegate = self
        containerView.backgroundColor = .defaultBg
    }
    
    private func bind(){
                       
    }
}

extension SearchView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
