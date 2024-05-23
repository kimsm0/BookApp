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

final class AppRootRouter: Router<AppRootInteractable, AppRootViewControllable> {
    
    private var bookSearchBuildable: BookSearchBuildable
    private var bookSearchRouting: Routing?
    
    init(interactor: AppRootInteractable,
         viewController: AppRootViewControllable,
         bookSearchBuildable: BookSearchBuildable
         
    ) {
        self.bookSearchBuildable = bookSearchBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }    
}

extension AppRootRouter: AppRootRouting {
    func attachBookSearch() {
        if bookSearchRouting == nil {
            let router = bookSearchBuildable.build(parentInteractor: interactable)
            bookSearchRouting = router
            attach(child: router)
            viewControllerable.setViewController(vc: router.viewController)
        }
    }
}


