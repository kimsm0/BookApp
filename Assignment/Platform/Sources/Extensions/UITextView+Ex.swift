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

public extension UITextView {
 
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification, object: self
        )
        .compactMap{ $0.object as? UITextView}
        .map{ $0.text ?? "" }
        .eraseToAnyPublisher()
     }
    
    var editBeginPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidBeginEditingNotification, object: self
        )
        .compactMap{ $0.object as? UITextView}
        .map{ $0.text ?? "" }
        .eraseToAnyPublisher()
     }
    
    var editEndPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidEndEditingNotification, object: self
        )
        .compactMap{ $0.object as? UITextView}
        .map{ $0.text ?? "" }
        .eraseToAnyPublisher()
     }
    
    func alignTextVertically(){
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
