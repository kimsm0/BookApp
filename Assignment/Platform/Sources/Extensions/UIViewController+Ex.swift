/**
 @class UIViewController+Ex.swift
 @date 5/20/24
 @writer kimsoomin
 @brief
 -공통으로 사용되는 네비게이션 영역을 구현
 -alert 함수 정의 
 @update history
 -
 */
import UIKit

public enum LeftNaviItem {
    case dismiss(DismissButtonType, AnyObject, Selector)
}

public enum RightNaviItem {
    case dismiss(DismissButtonType, AnyObject, Selector)
    
    public var iconSystemName: String {
        switch self {
        case .dismiss(let type, _, _):
            return type.iconSystemName
        }
    }
}

public enum DismissButtonType {
    case back, close, backWithText
    
    public var iconSystemName: String {
        switch self {
        case .back, .backWithText:
            return "chevron.backward"
        case .close:
            return "xmark"
        }
    }
    public var title: String {
      switch self {
      case .backWithText:
        return "뒤로"
      case .close, .back:
        return ""
      }
    }
}

public extension UIViewController {
    
    func setupNavigationItem(left: LeftNaviItem?,
                             right: RightNaviItem?,
                             title: String?,
                             isGuestureEnabled: Bool? = false
    ) {
        self.navigationItem.title = title
        
        let leftItem = UIBarButtonItem()
                
        if let left {
            switch left {
            case .dismiss(let type, let target, let selector):
                let button = UIButton()
                button.setImage(UIImage(systemName: type.iconSystemName,withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,weight: .semibold)), for: .normal)
                button.setTitle(type.title, for: .normal)
                button.setTitleColor(.systemBlue, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                button.addTarget(target, action: selector, for: .touchUpInside)
                button.frame.size.width = 60
                leftItem.accessibilityIdentifier = "todo_navi_back"
                leftItem.customView = button
            }
            leftItem.style = .plain
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = leftItem
        }
        
        if let right {
            let rightItem = UIBarButtonItem()
            switch right {
            case .dismiss(let type, let target, let selector):
                rightItem.image = UIImage(
                    systemName: type.iconSystemName,
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,
                                                                   weight: .regular)
                )
                rightItem.target = target
                rightItem.action = selector
                rightItem.accessibilityIdentifier = "todo_navi_dismiss"
            }
            rightItem.style = .plain
            //rightItem.tintColor = .black
            navigationItem.rightBarButtonItem = rightItem
        }
        
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }        
        navigationItem.titleView?.accessibilityIdentifier = "navigation_title"
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    func setNavigationTitle(title: String) {
        self.navigationItem.title = title
    }
    
    var topViewController: UIViewController {
        var top: UIViewController = self
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}

public extension UIViewController {
    func showAlert(title: String? = nil,
                   message: String,
                   confirmTitle: String,
                   cancelTitle: String? = nil,
                   confirmAction: (()->Void)? = nil,
                   cancelAction: (()->Void)? = nil 
    ) {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: confirmTitle, style: .default, handler: {_ in
            confirmAction?()
        })
        alert.addAction(confirm)
        
        if let cancelTitle = cancelTitle {
            let close = UIAlertAction(title: cancelTitle, style: .cancel, handler: {_ in
                cancelAction?()
            })
            alert.addAction(close)
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }        
    }
}


