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
protocol BookDetailRouting: Routing {
    
}

class BookDetailRouter: Router<BookDetailInteractable, BookDetailViewControllable> {
    
    override init(interactor: BookDetailInteractable,
                  viewController: BookDetailViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension BookDetailRouter: BookDetailRouting {
    
}
