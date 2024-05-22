
/**
 @class WebViewRouter
 @date 4/27/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import ArchitectureModule
import Extensions


// MARK: Router에서 구현해야할 프로토콜
protocol WebViewRouting: Routing {
    
}

class WebViewRouter: Router<WebViewInteractable, WebViewViewControllable> {
    
    override init(interactor: WebViewInteractable,
                  viewController: WebViewViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension WebViewRouter: WebViewRouting {
    
}
