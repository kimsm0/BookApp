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

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol BookDetailInteractableForPresenter: AnyObject {
    func didTapBackButton()
    func loadImage(url: String) -> AnyPublisher<(UIImage?, String), Never>
}

// 현재리블렛 -> 상위리블렛의 Interactor
public protocol BookDetailParentInteractable: AnyObject {
    func closeBookDetail()
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
protocol BookDetailInteractable: Interactable {
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
    }
    
    func fetchBookDetail(){
        dependency.bookRepository
            .getBookDetail(id: dependency.bookId)
            .receive(on: dependency.mainQueue)
            .sink { completion in
                
            } receiveValue: {[weak self] result in
                self?.presenter.update(result, interactor: self)
            }.store(in: &subscriptions)
    }
}

extension BookDetailInteractor: BookDetailInteractableForPresenter {
    func didTapBackButton() {
        parentInteractor?.closeBookDetail()
    }
        
    func loadImage(url: String) -> AnyPublisher<(UIImage?, String), Never> {
        return dependency.bookRepository.loadImage(url: url)
    }
}





