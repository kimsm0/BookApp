/**
 @class BookDetailInteractorDependencyMock
 @date 
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import BookRepository
import BookTestSupport

@testable import BookDetail
final class BookDetailInteractorDependencyMock: BookDetailInteractorDependency {
    var bookId: String
    
    var mainQueue: DispatchQueue {
        .main
    }
    var bookRepository: BookRepositoryType
    
    init(testCount: Int, bookId: String){
        self.bookId = bookId
        self.bookRepository = BookRepositoryMock(testCount: testCount)
    }
}
