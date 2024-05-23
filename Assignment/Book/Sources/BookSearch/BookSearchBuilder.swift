/**
 @class BookSearchBuilder
 @date
 @writer kimsoomin
 @brief
 - AppRoot에서 하위 리블렛으로 연결된 책 검색 화면 리블렛.
 - BookDetail 리블렛을 하위 리블렛으로 연결한다.
 @update history
 -
 */
import Foundation
import ArchitectureModule
import BookRepository
import BookDetail

public protocol BookSearchDependency: Dependency {
    var bookRepository: BookRepositoryType { get }
    var mainQueue: DispatchQueue { get }
}

final class BookSearchDependencyBox: DependencyBox<BookSearchDependency>, BookSearchInteractorDependency, BookDetailDependency {
        
    var bookRepository: BookRepositoryType{
        dependency.bookRepository
    }
    var mainQueue: DispatchQueue{
        dependency.mainQueue
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
                       
        let dependencyBox = BookSearchDependencyBox(dependency: dependency)
        
        let interactor = BookSearchInteractor(presenter: viewController,
                                              dependency: dependencyBox)
        interactor.parentInteractor = parentInteractor
        
        let bookDetailBuilder = BookDetailBuilder(dependency: dependencyBox)
        
        let router = BookSearchRouter(interactor: interactor,
                                      viewController: viewController,
                                      bookDetailBuildable: bookDetailBuilder)
        return router
    }
}

