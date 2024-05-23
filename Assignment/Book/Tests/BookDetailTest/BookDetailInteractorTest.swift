/**
 @class BookSearchInteractorTest
 @date
 @writer kimsoomin
 @brief
 - 책 상세 조회시에는 id 값으로 케이스를 구분한다. ( empty == fail, isbn13 == success, etc == empty)
 @update history
 -
 */

import XCTest
import BookDataModel
import BookTestSupport
import Combine

@testable import BookDetail

final class BookDetailInteractorTest: XCTestCase {
    
    private var sut: BookDetailInteractor!
    private var router: BookDetailRouterMock!
    private var presenter: BookDetailViewControllerMock!
    private var dependency: BookDetailInteractorDependencyMock!
    
    private let testCount = 1
    private var subscriptions = Set<AnyCancellable>()
    
    private let detail_result_empty = "test"
    private let detail_result_success = BookTestDouble.isbn13
    private let detail_result_fail = ""
    
    private var bookRepositoryMock: BookRepositoryMock {
        dependency.bookRepository as! BookRepositoryMock
    }
        
    override func setUpWithError() throws {
        super.setUp()

        self.dependency = BookDetailInteractorDependencyMock(testCount: testCount, bookId: detail_result_success)
        self.presenter = BookDetailViewControllerMock()
        
        let interactor = BookDetailInteractor(presenter: self.presenter,
                                            dependency: self.dependency)
        
        self.router = BookDetailRouterMock(interactor: interactor,
                                         viewController: presenter)
                                
        interactor.router = self.router
        sut = interactor
    }
    
    /*
     - 상세 진입 후 전달 받은 id로 API 응답 확인
     - repositoryMock에서 id 값으로 구분
     - id가 공백이 아닐 경우, 정상 응답
     
     1.주입한 테스트 데이터와 UI에 전달된 데이터가 일치하는지 확인
     2.인터렉터에서 데이터를 수신하면, UI 업데이트가 정상적으로 호출되는지 확인.
     3.UI에서 전달받은 인터렉터를 통해 이미지를 비동기 로드하고, 정상적으로 수신받는지 확인
     */
    func test_success_book_detail() {
        //given
        let expectation = XCTestExpectation(description: "test_success_book_detail")
        let expectation2 = XCTestExpectation(description: "test_success_book_detail2")
        //when
        sut.start()
        
        bookRepositoryMock.bookDetail
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
                
        wait(for: [expectation], timeout: 3)
                
        //then
        XCTAssertEqual(presenter.updateCallCount, 1)
        XCTAssertEqual(presenter.book?.title, BookTestDouble.getTestString(1, key: "title"))
        
        bookRepositoryMock.loadImage(url: "test")
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation2.fulfill()
            }.store(in: &subscriptions)
              
        wait(for: [expectation2], timeout: 3)
                
        XCTAssertEqual(presenter.imageKey, presenter.book?.image)
    }
    
    /*
     - 상세 조회 실패 케이스
     - repositoryMock에 id = ""으로 에러 케이스 생성 
     
     1. 에러 발생시 ui로 alert 정상 호출되는지 확인
     */
    func test_fail_book_detail(){
        //given
        let expectation = XCTestExpectation(description: "test_fail_book_detail")
        
        sut.start()
                                        
        bookRepositoryMock.resultError
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        //when
        bookRepositoryMock.getBookDetail(id: detail_result_fail)
                     
        wait(for: [expectation], timeout: 2)
              
        //then
        XCTAssertEqual(presenter.updateCallCount, 1)
    }
    
    /*
     - 상세 조회 empty 케이스
     - repositoryMock에 id != isbn13 으로 empty 케이스 생성
     
     1. empty data -> image load fail 케이스 확인
     */
    func test_fail_book_detail_empty(){
        //given
        let expectation = XCTestExpectation(description: "test_fail_book_detail_empty")
        
        sut.start()
                                        
        bookRepositoryMock.resultError
            .receive(on: DispatchQueue.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        //when
        bookRepositoryMock.getBookDetail(id: detail_result_empty)
                     
        wait(for: [expectation], timeout: 2)
              
        //then
        XCTAssertNil(presenter.imageKey)
    }
    
    /*
     - 상세화면에서 pdf보기 버튼 탭시, 웹뷰 리블렛 attach 확인
     */
    func test_attach_child_pdf() {
        //given
        sut.start()
        
        //when
        presenter.interactor?.didTapPdfButton()
        
        //then
        XCTAssertEqual(router.attachWebViewCount, 1)
    }
    /*
     - 상세화면에서 pdf보기 버튼 탭시, 웹뷰 리블렛 attach 확인
     */
    func test_attach_child() {
        //given
        sut.start()
        
        //when
        presenter.interactor?.didTapDetailButton()
        
        //then
        XCTAssertEqual(router.attachWebViewCount, 1)
    }
    
    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        
    }
}
