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

class BookSearchRouter: Router<BookSearchInteractable, BookSearchPresentable> {
    
    override init(interactor: BookSearchInteractable,
         presenter: BookSearchPresentable
    ) {
        super.init(interactor: interactor, presenter: presenter)
        interactor.router = self
    }
}

extension BookSearchRouter: BookSearchRouting {
    
}


