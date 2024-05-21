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


// MARK: Router에서 구현해야할 프로토콜 
protocol AppRootRouting: Routing {
    
}

class AppRootRouter: Router<AppRootInteractable, AppRootPresentable> {
    
    override init(interactor: AppRootInteractable,
         presenter: AppRootPresentable
    ) {
        super.init(interactor: interactor, presenter: presenter)
        interactor.router = self
    }
}

extension AppRootRouter: AppRootRouting {
    
}


