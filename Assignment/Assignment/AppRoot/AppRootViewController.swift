/**
 @class AppRootViewController
 @date 5/20/24
 @writer kimsoomin
 @brief
 - ViewController 클래스.
 - Presentable 프로토콜을 채택하여, ViewModel에서 접근 가능하도록 한다.
 - ViewControllerable 프로토콜을 채택하여, Coordinator에서 접근 가능하도록 한다.
 - ViewModelable 프로토콜을 통해 현재 컴포넌트의 ViewModel로 접근한다. 
 @update history
 -
 */
import UIKit
import ArchitectureModule
import Extensions

// MARK: ViewController에서 구현해야할 프로토콜들
// Router -> ViewController
protocol AppRootViewControllable: ViewControllable {
    func setViewController(vc: ViewControllable)
}

// Interator -> ViewController
protocol AppRootPresentable: Presentable {
    var interactor: AppRootInteractable? { get set }    
}

final class AppRootViewController: UINavigationController, AppRootPresentable, AppRootViewControllable {
    
    weak var interactor: AppRootInteractable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
    }
}

extension AppRootViewController {
    func setViewController(vc: ViewControllable) {
        self.setViewControllers([vc.uiviewController], animated: true)
    }
}

