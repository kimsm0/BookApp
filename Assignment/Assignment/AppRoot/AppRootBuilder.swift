/**
 @class AppRootBuilder
 @date 5/20/24
 @writer kimsoomin
 @brief
 - 리블렛의 구성 요소들의 초기화를 진행한다.
 - Buildable 프로토콜에 build 함수를 정의하고, 구현한다.
 @update history
 -
 */
import Foundation
import ArchitectureModule

protocol AppRootDependency: Dependency {
    
}

final class AppRootDependencyBox: DependencyBox<AppRootDependency> {
        
    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
/*
 Builder에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
protocol AppRootBuildable: Buildable {
    func build() -> Routing
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> Routing {
        let viewController = AppRootViewController()
        
        let dependencyBox = AppRootDependencyBox(
            dependency: dependency
        )
        
        let interactor = AppRootInteractor(presenter: viewController)
        let router = AppRootRouter(interactor: interactor,
                                   presenter: viewController)
        return router
    }
}

