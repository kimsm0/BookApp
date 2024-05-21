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


// MARK: Router에서 구현해야할 프로토콜
protocol BookSearchRouting: Routing {
    
}

class BookSearchRouter: Router<BookSearchInteractable, BookSearchViewControllable> {
    
    override init(interactor: BookSearchInteractable,
                  viewController: BookSearchViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }    
}

extension BookSearchRouter: BookSearchRouting {
    
}


