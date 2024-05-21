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

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol BookSearchInteractableForPresenter {
    
}

// 현재리블렛 -> 상위리블렛의 Interactor
public protocol BookSearchParentInteractable: AnyObject {
    
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
protocol BookSearchInteractable: Interactable {
    var router: BookSearchRouting? { get set }
    var parentInteractor: BookSearchParentInteractable? { get set }
}

class BookSearchInteractor: Interactor<BookSearchPresentable>, BookSearchInteractable {
    
    weak var router: BookSearchRouting?
    weak var parentInteractor: BookSearchParentInteractable?
    
    override init(presenter: BookSearchPresentable) {
        super.init(presenter: presenter)
        presenter.interactor = self
    }
        
    override func start() {
        
    }
}

extension BookSearchInteractor: BookSearchInteractableForPresenter {
    
}





