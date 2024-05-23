/**
 @class BookDetailBuilder
 @date
 @writer kimsoomin
 @brief
 - BookSearch 화면에서 검색 결과 cell을 탭하면 이동되는 상세화면 리블렛.
 - WebView 리블렛을 하위 리블렛으로 연결한다. 
 @update history
 -
 */


import Foundation
import ArchitectureModule
import BookRepository
import WebView

public protocol BookDetailDependency: Dependency {
    var bookRepository: BookRepositoryType { get }
    var mainQueue: DispatchQueue { get }
}

final class BookDetailDependencyBox: DependencyBox<BookDetailDependency>, BookDetailInteractorDependency,
WebViewDependency {
    var bookRepository: BookRepositoryType{
        dependency.bookRepository
    }
    var mainQueue: DispatchQueue{
        dependency.mainQueue
    }
    let bookId: String
    
    init(dependency: BookDetailDependency, bookId: String) {
        self.bookId = bookId
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
/*
 Builder에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
public protocol BookDetailBuildable: Buildable {
    func build(parentInteractor: BookDetailParentInteractable, bookId: String) -> Routing
}

public final class BookDetailBuilder: Builder<BookDetailDependency>, BookDetailBuildable {

    public override init(dependency: BookDetailDependency) {
        super.init(dependency: dependency)
    }

    public func build(parentInteractor: BookDetailParentInteractable, bookId: String) -> Routing {
        let viewController = BookDetailViewController()
                       
        let dependencyBox = BookDetailDependencyBox(dependency: dependency, bookId: bookId)
        
        let interactor = BookDetailInteractor(presenter: viewController,
                                              dependency: dependencyBox)
        interactor.parentInteractor = parentInteractor
        
        //child
        let webViewBuilder = WebViewBuilder(dependency: dependencyBox)
        
        let router = BookDetailRouter(interactor: interactor,
                                      viewController: viewController,
                                      webViewBuildable: webViewBuilder)
        return router
    }
}

