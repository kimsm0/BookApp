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

public final class SearchView: UIView {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let tfContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "검색어를 입력하세요."
        tf.borderStyle = .none
        tf.returnKeyType = .search
        tf.accessibilityIdentifier = "todo_main_textfield"
        tf.translatesAutoresizingMaskIntoConstraints = false
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
        self.backgroundColor = .yellow.withAlphaComponent(0.3)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -40),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 40),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 6),
            
            tfContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            tfContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            tfContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tfContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])          
    }
    
    private func attribute(){
        containerView.addLineShadow(location: .bottom)
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
