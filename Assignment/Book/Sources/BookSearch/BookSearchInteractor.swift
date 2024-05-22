/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import UIKit
import Combine
import ArchitectureModule
import BookDataModel
import BookRepository
import BookDetail

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol BookSearchInteractableForPresenter: AnyObject {
    func searchBooks(_ query: String)
    func didSelected(book: BookEntity)
    func loadMore()
    func loadImage(url: String) -> AnyPublisher<(UIImage?, String), Never>
}

// 현재리블렛 -> 상위리블렛의 Interactor
public protocol BookSearchParentInteractable: AnyObject {
    
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 하위 리블렛이 있다면, 하위 리블렛의 상위 리블렛 프로토콜을 채택하여야 한다. 
 */
protocol BookSearchInteractable: Interactable, BookDetailParentInteractable {
    var router: BookSearchRouting? { get set }
    var parentInteractor: BookSearchParentInteractable? { get set }
}

//Interactor에서 필요한 Dependency
protocol BookSearchInteractorDependency {
    var bookRepository: BookRepositoryType { get }    
    var mainQueue: DispatchQueue { get }
}

final class BookSearchInteractor: Interactor<BookSearchPresentable>, BookSearchInteractable {
    
    weak var router: BookSearchRouting?
    weak var parentInteractor: BookSearchParentInteractable?
    
    private let dependency: BookSearchInteractorDependency
    
    private var query: String?
    private var curPage: Int = 1
    
    private var bookTotalEntity: BookTotalEntity? {
        dependency.bookRepository.bookList.value
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(presenter: BookSearchPresentable,
         dependency: BookSearchInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.interactor = self
    }
    
    override func start() {
        bind()
    }
    
    func bind(){        
        dependency.bookRepository.bookList
            .receive(on: dependency.mainQueue)
            .dropFirst()
            .sink {[weak self] total in
                self?.presenter.update(total.books)
            }.store(in: &subscriptions)
        
        dependency.bookRepository.resultError
            .receive(on: dependency.mainQueue)
            .sink {[weak self] error in
                if let self, let error {
                    if error == .decodingError(type: .keyNotFound){
                        self.presenter.update([])
                    }else {
                        self.presenter.showAlert(message: "에러가 발생했습니다.\n잠시후 다시 시도해주세요.\(error.customCode)")
                    }                    
                }
            }.store(in: &subscriptions)
    }
}

extension BookSearchInteractor: BookSearchInteractableForPresenter {
    func searchBooks(_ query: String){
        guard self.query != query else {
            return
        }
        self.presenter.reset()
        self.query = query
        self.curPage = 1
        if !query.isEmpty {
            dependency.bookRepository.searchBooks(curPage: curPage, query: query)
        }       
    }
    
    func loadMore() {
        if let bookTotalEntity, 
            bookTotalEntity.total > bookTotalEntity.books.count,
            let query
        {
            curPage += 1
            dependency.bookRepository.searchBooks(curPage: curPage, query: query)
        }
    }
    
    func didSelected(book: BookEntity) {
        self.router?.attachBookDetail(id: book.isbn13)
    }
    
    func loadImage(url: String) -> AnyPublisher<(UIImage?, String), Never> {
        return dependency.bookRepository.loadImage(url: url)
    }
}

//하위리블렛 interactor에서 parentInteractor로 호출되는 부분
extension BookSearchInteractor {
    func closeBookDetail() {
        router?.detachBookDetail()
    }
}



