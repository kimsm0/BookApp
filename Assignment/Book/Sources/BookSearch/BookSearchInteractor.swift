/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import Combine
import ArchitectureModule
import BookDataModel
import BookRepository

// MARK: Interactor에서 구현해야할 프로토콜
// Presenter -> Interactor
protocol BookSearchInteractableForPresenter {
    func searchBooks(_ query: String)
}

// 현재리블렛 -> 상위리블렛의 Interactor
public protocol BookSearchParentInteractable: AnyObject {
    
}

/*
 Interactor에서 구현해야할 프로토콜
 다른 레이어에서 접근시 사용.
 */
protocol BookSearchInteractable: Interactable {
    var router: BookSearchRouting? { get set }
    var parentInteractor: BookSearchParentInteractable? { get set }
}

//Interactor에서 필요한 Dependency
protocol BookSearchInteractorDependency {
    var bookRepository: BookRepositoryType { get }
    var mainQueue: DispatchQueue { get }
}

class BookSearchInteractor: Interactor<BookSearchPresentable>, BookSearchInteractable {
    
    weak var router: BookSearchRouting?
    weak var parentInteractor: BookSearchParentInteractable?
    
    private let dependency: BookSearchInteractorDependency
    
    private var query: String?
    private var curPage: Int = 1
    
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
        self.presenter.showAlert(message: "")
        
        dependency.bookRepository.bookList
            .receive(on: dependency.mainQueue)
            .dropFirst()
            .sink {[weak self] total in
                //self?.presenter.update(with: total.data.items, needToScrollToTop: self?.curPage == 1)
            }.store(in: &subscriptions)
        
        dependency.bookRepository.resultError
            .receive(on: dependency.mainQueue)
            .sink {[weak self] error in
                if let self, let error {
                    self.presenter.showAlert(message: "에러가 발생했습니다.\n잠시후 다시 시도해주세요.\(error.customCode)")
                }
            }.store(in: &subscriptions)
    }
}

extension BookSearchInteractor: BookSearchInteractableForPresenter {
    func searchBooks(_ query: String){
        // TODO: query emtpy
        dependency.bookRepository.searchBooks(curPage: curPage, query: query)
    }
}





