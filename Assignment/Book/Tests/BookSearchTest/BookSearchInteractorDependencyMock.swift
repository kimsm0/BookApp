/**
 @class BookSearchInteractorDependencyMock
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import BookRepository
import BookTestSupport

@testable import BookSearch
final class BookSearchInteractorDependencyMock: BookSearchInteractorDependency {
    var mainQueue: DispatchQueue {
        .main
    }
    var bookRepository: BookRepositoryType
    
    init(testCount: Int){
        self.bookRepository = BookRepositoryMock(testCount: testCount)
    }
}
