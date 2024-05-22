/**
 @class BookRepository
 @date 5/21/24
 @writer kimsoomin
 @brief
 - Book 리블렛의 Network API 호출 클래스
 @update history
 -
 */
import UIKit
import Combine
import Utils
import Network
import BookDataModel
import Common
import CustomUI
import Storage

public protocol BookRepositoryType {
    var baseURLString: String { get }
    var bookList: ReadOnlyCurrentValuePublisher<BookTotalEntity> { get }
    var bookDetail: ReadOnlyCurrentValuePublisher<BookDetailEntity> { get }    
    var resultError: ReadOnlyCurrentValuePublisher<NetworkError?> { get }
    func searchBooks(curPage: Int, query: String)
    func getBookDetail(id: String)
    func loadImage(url: String) -> AnyPublisher<(UIImage?, String), Never>
}

public final class BookRepository: BookRepositoryType {
    
    public var bookList: ReadOnlyCurrentValuePublisher<BookTotalEntity> {
        bookListSubject
    }
    
    private let bookListSubject = CurrentValuePublisher<BookTotalEntity>(.init(total: 0,
                                                                               page: 0,
                                                                               books: []))
    
    public var bookDetail: ReadOnlyCurrentValuePublisher<BookDetailEntity> {
        bookDetailSubject
    }
    
    private let bookDetailSubject = CurrentValuePublisher<BookDetailEntity>(.initEntity())
    
    public var resultError: ReadOnlyCurrentValuePublisher<NetworkError?> {
        resultErrorSubject
    }
    
    private let resultErrorSubject = CurrentValuePublisher<NetworkError?>(nil)
        
    private let network: Network
    private let baseURL: URL
    private let imageCacheService: ImageCacheServiceType
        
    public var baseURLString: String {
        baseURL.absoluteString
    }
    private var subscriptions: Set<AnyCancellable>
    public init(network: Network, 
                baseURL: URL,
                imageCacheServie: ImageCacheServiceType
    ){
        self.subscriptions = .init()
        self.network = network
        self.baseURL = baseURL
        self.imageCacheService = imageCacheServie
    }
}

public extension BookRepository {
    
    func searchBooks(curPage: Int, query: String) {                
        LoadingView.showLoading()
        
        let request = BookSearhRequest(baseURL: baseURL, curPage: curPage, query: query)
        
         network
            .send(request)
            .map(\.output)
            .handleEvents(receiveOutput: {[weak self] output in
                LoadingView.hideLoading()
                var newEntity = output.toEntity()
                
                if curPage == 1 {
                    self?.bookListSubject.send(newEntity)
                }else {
                    var preValue = self?.bookListSubject.value?.books ?? []
                    preValue.append(contentsOf: output.books.map{ $0.toEntity() })
                    newEntity.books = preValue
                    self?.bookListSubject.send(newEntity)
                }
            }, receiveCompletion: {[weak self] completion in
                LoadingView.hideLoading()
                if case let .failure(error) = completion {
                    if let networkError = error as? NetworkError {
                        self?.resultErrorSubject.send(networkError)
                        printLog(networkError)
                    }else{
                        self?.resultErrorSubject.send(NetworkError.error(error, 999))
                        printLog(error)
                    }
                }
            })
            .sink(receiveCompletion: {[weak self] _ in
                self?.resultErrorSubject.send(nil)
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    func getBookDetail(id: String) {
        LoadingView.showLoading()
        let request = BookDetailRequest(baseURL: baseURL, id: id)
        
         network
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
            .handleEvents(receiveOutput: {[weak self] output in
                LoadingView.hideLoading()
                self?.bookDetailSubject.send(output)
            })
            .sink(receiveCompletion: {[weak self] _ in
                self?.resultErrorSubject.send(nil)
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    func loadImage(url: String) -> AnyPublisher<(UIImage?,String), Never> {
        imageCacheService.image(for: url)
            .eraseToAnyPublisher()            
    }
}
