/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import UIKit
import ArchitectureModule
import Combine
import BookRepository
import WebView

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol BookDetailInteractableForPresenter: AnyObject {
    func didTapBackButton()
    func didTapPdfButton()
    func didTapDetailButton()
    func loadImage(url: String) -> AnyPublisher<(UIImage?, String), Never>
}

// 현재리블렛 -> 상위리블렛의 Interactor
public protocol BookDetailParentInteractable: AnyObject {
    func closeBookDetail()
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 하위 리블렛이 있다면, 하위 리블렛의 상위 리블렛 프로토콜을 채택하여야 한다.
 */
protocol BookDetailInteractable: Interactable, WebViewParentInteractable {
    var router: BookDetailRouting? { get set }
    var parentInteractor: BookDetailParentInteractable? { get set }
}

//Interactor에서 필요한 Dependency
protocol BookDetailInteractorDependency {
    var bookRepository: BookRepositoryType { get }
    var mainQueue: DispatchQueue { get }
    var bookId: String { get }
}

class BookDetailInteractor: Interactor<BookDetailPresentable>, BookDetailInteractable {
    
    weak var router: BookDetailRouting?
    weak var parentInteractor: BookDetailParentInteractable?
    
    private let dependency: BookDetailInteractorDependency
    private var subscriptions = Set<AnyCancellable>()
    
    init(presenter: BookDetailPresentable,
         dependency: BookDetailInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.interactor = self
    }
    
    override func start() {
        bind()
        fetchBookDetail()
    }
    
    func bind(){
        dependency.bookRepository.resultError
            .receive(on: dependency.mainQueue)
            .sink {[weak self] error in
                if let self, let error {
                    self.presenter.showAlert(message: "에러가 발생했습니다.\n잠시후 다시 시도해주세요.\(error.customCode)")
                }
            }.store(in: &subscriptions)
        
        dependency.bookRepository.bookDetail
            .dropFirst()
            .receive(on: dependency.mainQueue)
            .sink {[weak self] detail in
                self?.presenter.update(detail, interactor: self)
            }.store(in: &subscriptions)
    }
    
    func fetchBookDetail(){
        dependency.bookRepository.getBookDetail(id: dependency.bookId)        
    }
}

extension BookDetailInteractor: BookDetailInteractableForPresenter {
    func didTapBackButton() {
        parentInteractor?.closeBookDetail()
    }
    
    func didTapDetailButton() {
        if let url = dependency.bookRepository.bookDetail.value?.url, !url.isEmpty{
            router?.attachWebView(type: WebViewType(contentType: .detail, url: url))
        }else{
            presenter.showAlert(message: "상세보기가 제공되지 않습니다.")
        }
    }
        
    func didTapPdfButton() {
        if let url = dependency.bookRepository.bookDetail.value?.pdf.chapter5, !url.isEmpty{
            router?.attachWebView(type: WebViewType(contentType: .pdf, url: url))
        }else if let url = dependency.bookRepository.bookDetail.value?.pdf.chapter2, !url.isEmpty{
            router?.attachWebView(type: WebViewType(contentType: .pdf, url: url))
        }else{
            presenter.showAlert(message: "PDF가 제공되지 않습니다.")
        }
    }
    func loadImage(url: String) -> AnyPublisher<(UIImage?, String), Never> {
        return dependency.bookRepository.loadImage(url: url)
    }
}

//WebViewParentInteractable
extension BookDetailInteractor {
    func closeWebView() {
        router?.detachWebView()
    }
}




