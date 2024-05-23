/**
 @class BookRepository
 @date 5/22/24
 @writer kimsoomin
 @brief
 - 테스트를 위한 Mock클래스
 - 책 검색시에는 curPage 값으로 케이스를 구분한다. (2 == loadMore케이스, 0 == success, -1 == fail)
 - 책 상세 조회시에는 id 값으로 케이스를 구분한다. ( empty == fail, isbn13 == success, etc == empty)
 @update history
 -
 */

import UIKit
import Combine
import Common
import Utils
import BookDataModel
import Storage
import BookRepository
import Network

public final class BookRepositoryMock: BookRepositoryType {
    public var baseURLString: String
    
    
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
    private let imageCacheService: ImageCacheServiceType = ImageCacheServiceMock()
        
    
    private let testCount: Int
    
    public init(testCount: Int){
        self.testCount = testCount
        self.baseURLString = ""
    }
}

public extension BookRepositoryMock {        
    func searchBooks(curPage: Int, query: String) {
        if curPage == 2 { //loadmore
            let loadMoreItem = BookTestDouble.getBookDTOs(testCount+1)
            var preValue = bookListSubject.value
            var preList = preValue?.books ?? []
            preList.append(contentsOf: loadMoreItem.map{ $0.toEntity()})
            preValue?.books = preList
            self.bookListSubject.send(preValue!)
        }else if curPage > 0 {
            let total = BookTestDouble.getBookTotalDTO(curPage)
            self.bookListSubject.send(total.toEntity())
        }else if curPage == -1 { //fail
            self.resultErrorSubject.send(.decodingError(type: .keyNotFound))
        }else {
            self.resultErrorSubject.send(.clientError)
        }
    }
    
    func getBookDetail(id: String) {
        if id.isEmpty {
            self.resultErrorSubject.send(.clientError)
        }else if id == BookTestDouble.isbn13{
            let detail = BookTestDouble.getBookDetailDTO(testCount)
            bookDetailSubject.send(detail.toEntity())
        }else {
            let detail = BookDetailEntity.initEntity()
            bookDetailSubject.send(detail)
        }
    }
    
    func loadImage(url: String) -> AnyPublisher<(UIImage?,String), Never> {
        imageCacheService.image(for: url)
            .eraseToAnyPublisher()
    }
}
