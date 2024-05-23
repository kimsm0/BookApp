/**
 @class AppRootTestBuildable
 @date
 @writer kimsoomin
 @brief
 - TestMode에 맞는 리블렛을 바로 Root에 attach 하기 위한 AppRootTest 리블렛.
 @update history
 -
 */

import Foundation
import ArchitectureModule
import BookSearch
import BookDetail
import WebView
import Network
import BookRepository

protocol AppRootTestDependency: Dependency {
    
}

final class AppRootTestDependencyBox: DependencyBox<AppRootTestDependency>, BookSearchDependency, BookDetailDependency, WebViewDependency {
        
    var mainQueue: DispatchQueue {
        .main
    }
    var bookRepository: BookRepositoryType
    
    override init(dependency: AppRootTestDependency) {
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [AppURLProtocol.self]
        setupURLProtocol()
        let network = NetworkImp(session: URLSession(configuration: config))
        
        self.bookRepository = BookRepository(network: network, baseURL: URL(string: API().baseURL)!, imageCacheServie: ImageCacheServiceMock())
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
/*
 Builder에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
protocol AppRootTestBuildable: Buildable {
    func build() -> Routing
}

final class AppRootTestBuilder: Builder<AppRootTestDependency>, AppRootTestBuildable {

    override init(dependency: AppRootTestDependency) {
        super.init(dependency: dependency)
    }

    func build() -> Routing {
        let viewController = AppRootViewController()
        
        let dependencyBox = AppRootTestDependencyBox(
            dependency: dependency
        )
        let interactor = AppRootTestInteractor(presenter: viewController)
        //child
        let bookSearchBuiler = BookSearchBuilder(dependency: dependencyBox)
        let bookDetailBuilder = BookDetailBuilder(dependency: dependencyBox)
        let webviewBuilder = WebViewBuilder(dependency: dependencyBox)
        
        let router = AppRootTestRouter(interactor: interactor,                                   
                                       viewController: viewController,
                                       bookSearchBuildable: bookSearchBuiler,
                                       bookDetailBuildable:bookDetailBuilder,
                                       webViewBuildable: webviewBuilder
                                       
        )
        return router
    }
}

