/**
 @class AppRootInteractor
 @date 5/20/24
 @writer kimsoomin
 @brief
 -
 @update history
 -
 */
import Foundation
import ArchitectureModule
import BookSearch

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol AppRootInteractableForPresenter {
    
}
// 현재리블렛 -> 상위리블렛의 Interactor
protocol AppRootParentInteractable {
    
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 하위 리블렛이 있다면, 하위 리블렛의 상위 리블렛 프로토콜을 채택하여야 한다. 
 */
protocol AppRootInteractable: Interactable, BookSearchParentInteractable {
    var router: AppRootRouting? { get set }
}

final class AppRootInteractor: Interactor<AppRootPresentable>, AppRootInteractable {
    
    weak var router: AppRootRouting?
    
    override init(presenter: AppRootPresentable) {
        super.init(presenter: presenter)
        presenter.interactor = self 
    }
        
    override func start() {
        router?.attachBookSearch()
    }
}

extension AppRootInteractor: AppRootInteractableForPresenter {
    
}





