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
import BookSearch
import BookDetail
import WebView
import BookTestSupport

// MARK: Router에서 구현해야할 프로토콜
protocol AppRootTestRouting: Routing {
    func attachBookSearch()
    func attachBookDetail()
    func attachWebView()
}

final class AppRootTestRouter: Router<AppRootTestInteractable, AppRootViewControllable> {
    
    private var bookSearchBuildable: BookSearchBuildable
    private var bookSearchRouting: Routing?
        
    private let bookDetailBuildable: BookDetailBuildable
    private var bookDetailRouting: Routing?
    
    private let webViewBuildable: WebViewBuildable
    private var webViewRouting: Routing?
 
    
    init(interactor: AppRootTestInteractable,
         viewController: AppRootViewControllable,
         bookSearchBuildable: BookSearchBuildable,
         bookDetailBuildable: BookDetailBuildable,
         webViewBuildable: WebViewBuildable
         
    ) {
        self.bookSearchBuildable = bookSearchBuildable
        self.bookDetailBuildable = bookDetailBuildable
        self.webViewBuildable = webViewBuildable
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension AppRootTestRouter: AppRootRouting, AppRootTestRouting {
    func attachBookSearch() {
        if bookSearchRouting == nil {
            let router = bookSearchBuildable.build(parentInteractor: interactable)
            bookSearchRouting = router
            attach(child: router)
            viewControllerable.setViewController(vc: router.viewController)
        }
    }
    
    func attachBookDetail() {
        if bookDetailRouting == nil {
            let router = bookDetailBuildable.build(parentInteractor: interactable, bookId: BookTestDouble.isbn13)
            bookDetailRouting = router
                              
            viewControllerable.setViewController(vc: router.viewController)
            attach(child: router)
        }
    }
    
    func attachWebView() {
        if webViewRouting == nil {                        
            let router = webViewBuildable.build(parentInteractor: interactable, type: WebViewType(contentType: BookTestDouble.testMode == .pdf ? .pdf : .detail, url: BookTestDouble.testMode.url))
            webViewRouting = router
            viewControllerable.setViewController(vc: router.viewController)
            attach(child: router)
        }
    }
}


