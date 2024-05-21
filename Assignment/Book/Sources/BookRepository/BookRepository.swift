/**
 @class BookRepository
 @date 5/21/24
 @writer kimsoomin
 @brief
 - Book 리블렛의 Network API 호출 클래스
 @update history
 -
 */
import Foundation
import Combine
import Utils
import Network
import BookDataModel
import Common
import CustomUI

public protocol BookRepositoryType {
    var baseURLString: String { get }
    var bookList: ReadOnlyCurrentValuePublisher<BookTotalEntity> { get }
    var resultError: ReadOnlyCurrentValuePublisher<NetworkError?> { get }
    func searchBooks(curPage: Int, query: String)
    func getBookDetail(id: String) -> AnyPublisher<BookDetailEntity, NetworkError>
}

public final class BookRepository: BookRepositoryType {
    
    public var bookList: ReadOnlyCurrentValuePublisher<BookTotalEntity> {
        bookListSubject
    }
    
    private let bookListSubject = CurrentValuePublisher<BookTotalEntity>(.init(total: "",
                                                                               page: "",
                                                                               books: []))
    public var resultError: ReadOnlyCurrentValuePublisher<NetworkError?> {
        resultErrorSubject
    }
    
    private let resultErrorSubject = CurrentValuePublisher<NetworkError?>(nil)
        
    private let network: Network
    private let baseURL: URL
        
    public var baseURLString: String {
        baseURL.absoluteString
    }
    private var subscriptions: Set<AnyCancellable>
    public init(network: Network, baseURL: URL){
        self.subscriptions = .init()
        self.network = network
        self.baseURL = baseURL
    }
}

public extension BookRepository {
    
    func searchBooks(curPage: Int, query: String) {
        LoadingView.showLoading()
        
        let request = BookSearhRequest(baseURL: baseURL, curPage: curPage, query: query)
        
         network
            .send(request)
            .map(\.output)
            .handleEvents(receiveOutput: { output in
                LoadingView.hideLoading()
                var newEntity = output.toEntity()
                
                if curPage == 1 {
                    self.bookListSubject.send(newEntity)
                }else {
                    var preValue = self.bookListSubject.value?.books ?? []
                    preValue.append(contentsOf: output.books.map{ $0.toEntity() })
                    newEntity.books = preValue
                    self.bookListSubject.send(newEntity)
                }
            }, receiveCompletion: { completion in
                LoadingView.hideLoading()
                if case let .failure(error) = completion {
                    if let networkError = error as? NetworkError {
                        self.resultErrorSubject.send(networkError)
                        printLog(networkError)
                    }else{
                        self.resultErrorSubject.send(NetworkError.error(error, 999))
                        printLog(error)
                    }
                }
            })
            .sink(receiveCompletion: {_ in }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    func getBookDetail(id: String) -> AnyPublisher<BookDetailEntity, NetworkError> {
        LoadingView.showLoading()
        let request = BookDetailRequest(baseURL: baseURL, id: id)
        
        return network
            .send(request)
            .map(\.output)
            .map{ $0.toEntity() }
            .mapError{[weak self] error in
                if let networkError = error as? NetworkError {
                    self?.resultErrorSubject.send(networkError)
                    return networkError
                }else {
                    self?.resultErrorSubject.send(NetworkError.error(error,999))
                    return NetworkError.error(error,999)
                }
            }
            .handleEvents(receiveCompletion: { completion in
                LoadingView.hideLoading()
            })
            .eraseToAnyPublisher()
    }
}
