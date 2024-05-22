/**
 @class WebViewBuilder
 @date 4/27/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import ArchitectureModule

public protocol WebViewDependency: Dependency {
    
}

final class WebViewDependencyBox: DependencyBox<WebViewDependency>, WebViewInteractorDependency {
    var type: WebViewType
    
    init(dependency: WebViewDependency, type: WebViewType) {
        self.type = type
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
/*
 Builder에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
public struct WebViewType {
    public enum WebViewContentType {
        case pdf
        case detail
        
        var title: String {
            switch self{
            case .pdf:
                return "PDF 상세보기"
            case .detail:
                return "더보기"
            }
        }
    }
    public let contentType: WebViewContentType
    public let url: String
    
    public init(contentType: WebViewContentType, 
                url: String
    ) {
        self.contentType = contentType
        self.url = url
    }
}
public protocol WebViewBuildable: Buildable {
    func build(parentInteractor: WebViewParentInteractable, type: WebViewType) -> Routing
}

public final class WebViewBuilder: Builder<WebViewDependency>, WebViewBuildable {

    public override init(dependency: WebViewDependency) {
        super.init(dependency: dependency)
    }

    public func build(parentInteractor: WebViewParentInteractable, type: WebViewType) -> Routing {
        let viewController = WebViewController()
                       
        let dependencyBox = WebViewDependencyBox(dependency: dependency, type: type)
        
        let interactor = WebViewInteractor(presenter: viewController,
                                              dependency: dependencyBox)
        interactor.parentInteractor = parentInteractor
        
        let router = WebViewRouter(interactor: interactor,
                                      viewController: viewController)
        return router
    }
}

