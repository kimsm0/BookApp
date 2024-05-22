import XCTest
import Foundation
import BookTestSupport
import BookDataModel

final class BookDetailUITest: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
        
    func test_book_detail() throws {
        app.launch()
        
        /*
         네비게이션 바 텍스트 확인
         */
        XCTAssertTrue(isDisplayed(app.navigationBars.staticTexts["책 상세"]))
        
        /*
         상세 화면 확인
         */
        XCTAssertTrue(isDisplayed(app.images["bookdetail_imageview"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["bookdetail_title"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["bookdetail_subtitle"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["bookdetail_author"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["bookdetail_publisher"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["bookdetail_desc"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["bookdetail_isbn"]))
        XCTAssertTrue(isDisplayed(app.staticTexts["bookdetail_price"]))
        XCTAssertTrue(isDisplayed(app.buttons["bookdetail_pdf_button"]))
        XCTAssertTrue(isDisplayed(app.buttons["bookdetail_detail_button"]))
        
        let book = BookTestDouble.getBookDetailDTO(1)
        
        /*
         데이터 정합성 확인
         */
        XCTAssertEqual(app.staticTexts["bookdetail_title"].label, book.title)
        XCTAssertEqual(app.staticTexts["bookdetail_subtitle"].label, book.subtitle)
        XCTAssertEqual(app.staticTexts["bookdetail_author"].label, book.authors)
        XCTAssertEqual(app.staticTexts["bookdetail_price"].label, book.price)
        XCTAssertEqual(app.staticTexts["bookdetail_desc"].label, book.desc)
        XCTAssertEqual(app.staticTexts["bookdetail_isbn"].label, "\(book.isbn10) / \(book.isbn13)")
        XCTAssertEqual(app.staticTexts["bookdetail_publisher"].label, "\(book.publisher) / YEAR: \(book.year) / PAGE: \(book.pages)")
        
        /*
         pdf버튼 탭하면 웹뷰로 이동되는지 확인
         */
        let pdf = app.buttons["bookdetail_pdf_button"]
        let detail = app.buttons["bookdetail_detail_button"]
        
        pdf.tap()
        XCTAssertTrue(isDisplayed(app.navigationBars.staticTexts["PDF 상세보기"]))
        
        app.navigationBars.buttons["navi_back"].tap()
        
        detail.tap()
        XCTAssertTrue(isDisplayed(app.navigationBars.staticTexts["더보기"]))
    }

    override func tearDownWithError() throws {
        
    }
}
