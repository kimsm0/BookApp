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

public protocol BookSearchDependency: Dependency {
    
}

final class BookSearchDependencyBox: DependencyBox<BookSearchDependency> {
        
    override init(dependency: BookSearchDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
/*
 Builder에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
public protocol BookSearchBuildable: Buildable {
    func build(parentInteractor: BookSearchParentInteractable) -> Routing
}

public final class BookSearchBuilder: Builder<BookSearchDependency>, BookSearchBuildable {

    public override init(dependency: BookSearchDependency) {
        super.init(dependency: dependency)
    }

    public func build(parentInteractor: BookSearchParentInteractable) -> Routing {
        let viewController = BookSearchViewController()
                        
        let interactor = BookSearchInteractor(presenter: viewController)
        interactor.parentInteractor = parentInteractor
        
        let router = BookSearchRouter(interactor: interactor,
                                   presenter: viewController)
        return router
    }
}

