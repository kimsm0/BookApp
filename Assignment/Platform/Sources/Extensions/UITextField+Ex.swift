/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import UIKit
import Combine

public extension UITextField {
    
    var curTextPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { $0.object as? UITextField }
        .map { $0.text ?? "" }
        .eraseToAnyPublisher()
    }
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidEndEditingNotification,
            object: self
        )
        .compactMap { $0.object as? UITextField }
        .map {
            $0.resignFirstResponder()
            return $0.text ?? ""
        }
        .eraseToAnyPublisher()
    }
    
    var editBeginPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidBeginEditingNotification,
            object: self
        )
        .map{_ in }
        .eraseToAnyPublisher()
    }
}
