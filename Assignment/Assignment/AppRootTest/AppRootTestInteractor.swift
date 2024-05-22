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
import BookSearch
import BookDetail
import WebView
import BookTestSupport

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol AppRootTestInteractableForPresenter {
    
}
// 현재리블렛 -> 상위리블렛의 Interactor
protocol AppRootTestParentInteractable {
    
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 하위 리블렛이 있다면, 하위 리블렛의 상위 리블렛 프로토콜을 채택하여야 한다.
 */
protocol AppRootTestInteractable: Interactable, BookSearchParentInteractable, WebViewParentInteractable, BookDetailParentInteractable {
    var router: AppRootTestRouting? { get set }
}

class AppRootTestInteractor: Interactor<AppRootPresentable>, AppRootTestInteractable {
    
    weak var router: AppRootTestRouting?
    
    override init(presenter: AppRootPresentable) {
        super.init(presenter: presenter)
        //presenter.interactor = self
    }
        
    override func start() {
        #if UITESTING
        switch BookTestDouble.testMode {
        case.main:
            router?.attachBookSearch()
        case .detail:
            router?.attachBookDetail()
        case .detailMore, .pdf:
            router?.attachWebView()
        }
        #else
        router?.attachBookSearch()
        #endif
    }
}

extension AppRootTestInteractor: AppRootInteractableForPresenter {
    func closeWebView() {
    }
    
    func closeBookDetail() {
    }
}





