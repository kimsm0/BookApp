/**
 @class Toast
 @date
 @writer kimsoomin
 @brief
 - 토스트 메시지 뷰 
 @update history
 -
 */
import UIKit
import Extensions

public final class Toast {
    public static func showToast(message: String, subMessage:String = "") {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first {
                
                if let parentView = window.viewWithTag(12345) {
                    parentView.removeFromSuperview()
                }
                
                let stackView: UIStackView = {
                    let stackView = UIStackView()
                    stackView.backgroundColor = .defaultShadow.withAlphaComponent(0.9)
                    stackView.axis = .vertical
                    stackView.tag = 12345
                    stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                    stackView.isLayoutMarginsRelativeArrangement = true
                    stackView.insetsLayoutMarginsFromSafeArea = false
                    stackView.layer.cornerRadius = 4
                    stackView.translatesAutoresizingMaskIntoConstraints = false 
                    return stackView
                }()
                             
                window.addSubview(stackView)
                
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: window.topAnchor, constant: 50),
                    stackView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
                    stackView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
                ])
                
                
                let label: UILabel = {
                    let label = UILabel()
                    label.textColor = .defaultBg
                    label.text = subMessage != "" ? "\(message)\n\(subMessage)":"\(message)"
                    label.alpha = 1.0
                    label.clipsToBounds  =  true
                    label.numberOfLines = 0
                    label.textAlignment = .center
                    label.accessibilityIdentifier = "toast_view_label"
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                }()
                
                if subMessage != ""{
                    let attributedString = NSMutableAttributedString(string: "\(label.text ?? "")", attributes: nil)
                    let colorRange = (attributedString.string as NSString).range(of: "\(subMessage)")
                    attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: colorRange)
                    label.attributedText = attributedString
                }
                   
                stackView.addArrangedSubview(label)                
                
                let animater = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut) {
                    stackView.alpha = 0.0
                }
                
                animater.addCompletion { position in
                    switch position {
                    case .end:
                        stackView.removeFromSuperview()
                        break
                    default:
                        break
                    }
                }                
                animater.startAnimation(afterDelay: 3)
            }
        }
    }
}
