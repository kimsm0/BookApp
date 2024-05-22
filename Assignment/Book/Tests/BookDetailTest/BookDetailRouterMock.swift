/**
 @class BookDetailRouterMock
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
@testable import BookDetail

import Foundation
import ArchitectureModule
import WebView

class BookDetailRouterMock: Router<BookDetailInteractable, BookDetailViewControllable> {
          
    var attachWebViewCount = 0
    var detachWebViewCount = 0
    
    override init(interactor: BookDetailInteractable,
         viewController: BookDetailViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension BookDetailRouterMock: BookDetailRouting {
    func attachWebView(type: WebViewType) {
        attachWebViewCount += 1
    }
    
    func detachWebView() {
        detachWebViewCount += 1
    }
}



