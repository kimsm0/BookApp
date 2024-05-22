/**
 @class TodoMainUITest
 @date 5/5/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import XCTest
import Foundation
import BookTestSupport
import BookDataModel

final class BookSearchUITest: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    
    func test_book_search() throws {
        app.launch()
        
        /*
         네비게이션 바 텍스트 확인
         */
        XCTAssertTrue(isDisplayed(app.navigationBars.staticTexts["책 검색"]))
        /*
         가이드 텍스트 확인 
         */
        XCTAssertTrue(isDisplayed(app.staticTexts["bookSearch_guide"]))
        
        //상단 검색 영역 텍스트 필드
        let textField = app.textFields["search_textfield"]
        textField.tap()
        
        //텍스트 필드 입력 후 검색 진행
        textField.typeText("\(BookTestDouble.searchKeyword)")
        app.keyboards.buttons["Search"].tap()
        
        
        //결과 테이블 뷰
        let tableView = app.tables["bookSearch_tableview"]
        
        /*
         검색 결과 화면 확인
         */
        XCTAssertTrue(isDisplayed(app.images["book_search_cell_image"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["book_search_cell_title"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["book_search_cell_subtitle"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["book_search_cell_isbn13"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["book_search_cell_price"]))
        
        let testTotal = BookTestDouble.getBookTotalDTO(1)
        let book: BookDTO = testTotal.books[safe: 0]!
        
        /*
         데이터 정합성 확인
         */
        XCTAssertEqual(app.staticTexts["book_search_cell_title"].label, book.title)
        XCTAssertEqual(app.staticTexts["book_search_cell_subtitle"].label, book.subtitle)
        XCTAssertEqual(app.staticTexts["book_search_cell_isbn13"].label, book.isbn13)
        XCTAssertEqual(app.staticTexts["book_search_cell_price"].label, book.price)

        
        /*
         리스트에서 항목을 탭하면 상세로 이동되는지 확인
         */
        tableView.cells.element(boundBy: 0).tap()
        XCTAssertTrue(isDisplayed(app.navigationBars.staticTexts["책 상세"]))
    }

    override func tearDownWithError() throws {
        
    }
}
