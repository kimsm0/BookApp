/**
 @class
 @date 5/20/24
 @writer kimsoomin
 @brief
 - Router에서 UIKit을 import하지 않기 위해, NavigationControllerable 클래스를 생성하여 접근한다.
 - UIViewController에서는 present/push 등의 메서드가 제공되지 않아 편의성을 위해 extension으로 확장하여 정의함.
 @update history
 -
 */
import UIKit

public protocol ViewControllable: AnyObject {
    var uiviewController: UIViewController { get }
}

public extension ViewControllable where Self: UIViewController {
    var uiviewController: UIViewController {
        return self
    }
}

public final class NavigationControllerable: ViewControllable {
    
    public var uiviewController: UIViewController { self.navigationController }
    public let navigationController: UINavigationController
    
    public init(root: ViewControllable) {
        let navigation = UINavigationController(rootViewController: root.uiviewController)
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.backgroundColor = .defaultBg
        navigation.navigationBar.scrollEdgeAppearance = navigation.navigationBar.standardAppearance
        
        self.navigationController = navigation
    }
}


public extension ViewControllable {
    
    func present(_ viewControllable: ViewControllable, animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async {[weak self] in
            self?.uiviewController.present(viewControllable.uiviewController, animated: animated, completion: completion)
        }
    }
    
    func dismiss(completion: (() -> Void)?) {
        DispatchQueue.main.async {[weak self] in
            self?.uiviewController.dismiss(animated: true, completion: completion)
        }
    }
    
    func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
        DispatchQueue.main.async {[weak self] in
            if let nav = self?.uiviewController as? UINavigationController {
                nav.pushViewController(viewControllable.uiviewController, animated: animated)
            } else {
                self?.uiviewController.navigationController?.pushViewController(viewControllable.uiviewController, animated: animated)
            }
        }
    }
    
    func popViewController(animated: Bool) {
        DispatchQueue.main.async {[weak self] in
            if let nav = self?.uiviewController as? UINavigationController {
                nav.popViewController(animated: animated)
            } else {
                self?.uiviewController.navigationController?.popViewController(animated: animated)
            }
        }
    }
    
    func popToRoot(animated: Bool) {
        DispatchQueue.main.async {[weak self] in
            if let nav = self?.uiviewController as? UINavigationController {
                nav.popToRootViewController(animated: animated)
            } else {
                self?.uiviewController.navigationController?.popToRootViewController(animated: animated)
            }
        }
    }
    
    func setViewControllers(_ viewControllerables: [ViewControllable]) {
        DispatchQueue.main.async {[weak self] in
            if let nav = self?.uiviewController as? UINavigationController {
                nav.setViewControllers(viewControllerables.map(\.uiviewController), animated: true)
            } else {
                self?.uiviewController.navigationController?.setViewControllers(viewControllerables.map(\.uiviewController), animated: true)
            }
        }        
    }
    
    var topViewControllable: ViewControllable {
        var top: ViewControllable = self
        while let presented = top.uiviewController.presentedViewController as? ViewControllable  {
            top = presented
        }
        return top
    }
}


