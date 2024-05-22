
@testable import BookSearch

import Foundation
import ArchitectureModule

class BookSearchRouterMock: Router<BookSearchInteractable, BookSearchViewControllable>{
    
    public var attachBookDetailCallCount = 0
    public var detachBookDetailCallCount  = 0
    
    override init(interactor: BookSearchInteractable,
         viewController: BookSearchViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension BookSearchRouterMock: BookSearchRouting {
    func attachBookDetail(id: String) {
        attachBookDetailCallCount += 1
    }
    
    func detachBookDetail() {
        detachBookDetailCallCount += 1
    }
}


