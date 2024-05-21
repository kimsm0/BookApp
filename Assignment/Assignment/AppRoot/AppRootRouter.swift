/**
 @class AppRootCoordinator
 @date 5/20/24
 @writer kimsoomin
 @brief
 -
 @update history
 -
 */
import Foundation
import ArchitectureModule
import Extensions
import BookSearch

// MARK: Router에서 구현해야할 프로토콜 
protocol AppRootRouting: Routing {
    func attachBookSearch()
}

class AppRootRouter: Router<AppRootInteractable, AppRootPresentable> {
    
    private var bookSearchBuildable: BookSearchBuildable
    private var bookSearchRouting: Routing?
    
    init(interactor: AppRootInteractable,
                  presenter: AppRootPresentable,
                  bookSearchBuildable: BookSearchBuildable
                  
    ) {
        self.bookSearchBuildable = bookSearchBuildable
        super.init(interactor: interactor, presenter: presenter)
        interactor.router = self
    }
}

extension AppRootRouter: AppRootRouting {
    func attachBookSearch() {
        if bookSearchRouting == nil {
            let router = bookSearchBuildable.build(parentInteractor: interactable)
            bookSearchRouting = router
            attach(child: router)
            presentable.setViewController(vc: router.presenter)
        }
    }
}


