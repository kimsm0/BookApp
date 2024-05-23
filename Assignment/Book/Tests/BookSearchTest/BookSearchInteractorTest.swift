/**
 @class BookSearchInteractorTest
 @date
 @writer kimsoomin
 @brief
 - 책 검색시에는 curPage 값으로 케이스를 구분한다. (2 == loadMore케이스, 1 == success(default case), -1 == decoding error, -2 == error)
 @update history
 -
 */

import XCTest
import BookDataModel
import BookTestSupport
import Combine

@testable import BookSearch

final class BookSearchInteractorTest: XCTestCase {

    private var sut: BookSearchInteractor!
    private var router: BookSearchRouterMock!
    private var presenter: BookSearchViewControllerMock!
    private var dependency: BookSearchInteractorDependencyMock!
    
    private let testCount = 1
    private var subscriptions = Set<AnyCancellable>()
    
    private let search_success_case = 1
    private let search_decoding_error_case = -1
    private let search_fail_case = -2
    private let search_loadmore_case = 2
    
    private var bookRepositoryMock: BookRepositoryMock {
        dependency.bookRepository as! BookRepositoryMock
    }
        
    override func setUpWithError() throws {
        super.setUp()

        self.dependency = BookSearchInteractorDependencyMock(testCount: testCount)
        self.presenter = BookSearchViewControllerMock()
        
        let interactor = BookSearchInteractor(presenter: self.presenter,
                                            dependency: self.dependency)
        
        self.router = BookSearchRouterMock(interactor: interactor,
                                         viewController: presenter)
                                
        interactor.router = self.router
        sut = interactor
    }
    
    /*
     - 검색 후 loadMore 동작 확인
     - repository Mock 에서 curpage 로 케이스 구분.
     - curPage = 2 로 loadMore를 확인
     
     1.test data 주입한 갯수와 같은지 확인 (인터렉터에서 UI로 전달하는 데이터 정상적으로 전달되는지 확인)
     2.인터렉터에서 데이터를 수신하면, UI 업데이트가 정상적으로 호출되는지 확인.
     */
    func test_success_book_list_loadmore() {
        //given
        let expectation = XCTestExpectation(description: "test_success_book_list_loadmore")
        //when
        sut.start()
        sut.searchBooks("test")
        bookRepositoryMock.searchBooks(curPage: search_loadmore_case, query: "test")
        
        bookRepositoryMock.bookList
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
              
       wait(for: [expectation], timeout: 2)
        
        //then
        XCTAssertEqual(presenter.updateCallCount, 2)
        XCTAssertEqual(presenter.dataCount, 3)
    }
    
    /*
     - 검색 정상 케이스 확인
     - 디폴트 케이스인 default(testCount = 1) : 1개 데이터 로드
     
     1.test data 주입한 갯수와 같은지 확인 (인터렉터에서 UI로 전달하는 데이터 정상적으로 전달되는지 확인)
     2.인터렉터에서 데이터를 수신하면, UI 업데이트가 정상적으로 호출되는지 확인.
     3.검색어를 입력하여 진행시 기존 데이터를 reset하고 로드가 진행되는지 확인
     */
    func test_success_book_list_default(){
        //given
        let expectation = XCTestExpectation(description: "test_search")
        
        sut.start()
        sut.searchBooks(BookTestDouble.getTestString(1, key: "test"))
                                
        bookRepositoryMock.bookList
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
              
       wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(presenter.resetCount, 1)
        XCTAssertEqual(presenter.updateCallCount, 1)
        XCTAssertEqual(presenter.dataCount, 1)
    }
    
    /*
     - 에러케이스 확인
     - curPage를 -1로 호출하여 decoding error 리턴 케이스 생성
     1.keynotfound 발생시 ui 데이터 초기화 확인
     */
    func test_fail_booklist_decoding_error() {
        //given
        let expectation = XCTestExpectation(description: "test_fail_booklist_decoding_error")
        sut.start()
        
        //when
        dependency.bookRepository
            .searchBooks(curPage: search_decoding_error_case, query: "")
        
        bookRepositoryMock.resultError
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
              
       wait(for: [expectation], timeout: 2)
        
        //then
        XCTAssertEqual(presenter.dataCount, 0)
    }
    /*
     - 에러케이스 확인
     - curPage를 -2로 호출하여 error 리턴 케이스 생성
     1. 에러 발생시 ui로 alert 정상 호출되는지 확인
     */
    func test_fail_booklist_error() {
        //given
        let expectation = XCTestExpectation(description: "test_fail_booklist_error")
        sut.start()
        
        //when
        dependency.bookRepository
            .searchBooks(curPage: search_fail_case, query: "")
        
        bookRepositoryMock.resultError
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
              
       wait(for: [expectation], timeout: 2)
        
        //then
        XCTAssertEqual(presenter.showAlertCallCount, 1)
    }
    
    /*
     하위 리블렛 연결 로직 확인
     1. UI에서 cell 선택시 인터렉터에서 액션을 받아 라우터에서 정상적으로 하위 리블렛 attach가 진행되는지 확인
     */
    func test_didSelectDetail() {
        //given
        sut.start()
        //when
        presenter.interactor?
            .didSelected(book: BookTestDouble.getBookDTOs(1).first!.toEntity())
                        
        //then
        XCTAssertEqual(router.attachBookDetailCallCount, 1)
    }
    
    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        
    }
}
