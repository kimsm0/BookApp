
/**
 @class WebViewInteractor
 @date 4/27/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import ArchitectureModule

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol WebViewInteractableForPresenter: AnyObject {
    func didTapBackButton()
}

// 현재리블렛 -> 상위리블렛의 Interactor
public protocol WebViewParentInteractable: AnyObject {
    func closeWebView()
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
protocol WebViewInteractable: Interactable {
    var router: WebViewRouting? { get set }
    var parentInteractor: WebViewParentInteractable? { get set }
}

//Interactor에서 필요한 Dependency
protocol WebViewInteractorDependency {    
    var type: WebViewType { get }
}

class WebViewInteractor: Interactor<WebViewPresentable>, WebViewInteractable {
    
    weak var router: WebViewRouting?
    weak var parentInteractor: WebViewParentInteractable?
    
    private let dependency: WebViewInteractorDependency
    
    init(presenter: WebViewPresentable,
         dependency: WebViewInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.interactor = self
    }
    
    override func start() {
        loadWebView()
    }
        
    
    func loadWebView(){
        presenter.loadWebView(type: dependency.type)        
    }
}

extension WebViewInteractor: WebViewInteractableForPresenter {
    func didTapBackButton() {
        parentInteractor?.closeWebView()
    }            
}





