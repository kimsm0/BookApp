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

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol AppRootInteractableForPresenter {
    
}
// 하위리블렛 -> 현재(상위) Interactor
protocol AppRootInteractableForChild {
    
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
protocol AppRootInteractable: Interactable {
    var router: AppRootRouting? { get set }
}

class AppRootInteractor: Interactor<AppRootPresentable>, AppRootInteractable {
    
    weak var router: AppRootRouting?
    
    override init(presenter: AppRootPresentable) {
        super.init(presenter: presenter)
        presenter.interactor = self 
    }
        
    override func start() {
        
    }
}

extension AppRootInteractor: AppRootInteractableForPresenter {
    
}

extension AppRootInteractor: AppRootInteractableForChild {
    
}



