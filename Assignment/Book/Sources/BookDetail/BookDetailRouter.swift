/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import ArchitectureModule
import Extensions
import WebView

// MARK: Router에서 구현해야할 프로토콜
protocol BookDetailRouting: Routing {
    func attachWebView(type: WebViewType)
    func detachWebView()
}

class BookDetailRouter: Router<BookDetailInteractable, BookDetailViewControllable>, AdaptiveInteractionGestureDelegate {
    
    private var webViewBuildable: WebViewBuildable
    private var webViewRouting: Routing?
    
    private var interactionGuestureProxy: AdaptiveInteractionGestureDelegateProxy?
    
    init(interactor: BookDetailInteractable,
                  viewController: BookDetailViewControllable,
                  webViewBuildable: WebViewBuildable
    ) {
        self.webViewBuildable = webViewBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension BookDetailRouter: BookDetailRouting {
    func attachWebView(type: WebViewType) {
        if webViewRouting == nil {
            self.interactionGuestureProxy = AdaptiveInteractionGestureDelegateProxy(viewController: viewController)
            self.interactionGuestureProxy?.delegate = self
            
            let router = webViewBuildable.build(parentInteractor: interactable, type: type)
            webViewRouting = router
            viewController.uiviewController.navigationController?.pushViewController(router.viewController.uiviewController, animated: true)
            attach(child: router)
        }
    }
    
    func detachWebView() {
        if let router = webViewRouting {
            viewController.uiviewController.navigationController?.popViewController(animated: true)
            detach(child: router)
            webViewRouting = nil
        }
    }
    
    func detactedInteractionGuesture() {
        if let router = webViewRouting {
            detach(child: router)
            webViewRouting = nil
        }        
    }
}
