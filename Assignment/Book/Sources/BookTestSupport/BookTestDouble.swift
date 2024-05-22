/**
 @class BookTestDouble
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import Extensions
import BookDataModel

public enum BookTestMode{
    case main
    case detail
}
public struct BookTestDouble {
    public static var testMode: BookTestMode = .main
    
    public static let isbn13 = "9781617294136"
    public static let pdfURL = "https://itbook.store/files/9781617294136/chapter5.pdf"
    public static let detailURL = "https://itbook.store/books/9781617294136"
    public static let imageURL = "https://itbook.store/img/books/9781617294136.png"
            
    public static func getBookTotalDTO(_ with: Int) -> BookTotalDTO {
        if with > 0 {
            return BookTotalDTO(total: "\(with)", page: "\(with)", books: getBookDTOs(with))
        }else {
            return BookTotalDTO(total: "0", page: "0", books: [])
        }
    }
    
    public static func getBookDTOs(_ with: Int) -> [BookDTO] {
        var arr: [BookDTO] = []
        for i in 1..<with+1 {
            arr.append(.init(title: getTestString(with, key: "title"),
                             subtitle: getTestString(with, key: "subtitle"),
                             isbn13: isbn13,
                             price: getTestString(with, key: "price"),
                             image: imageURL,
                             url: detailURL))            
        }
        return arr
    }
    
    public static func getBookDetailDTO(_ with: Int) -> BookDetailDTO {    
        BookDetailDTO(error: getTestString(with, key: "error"),
                      title: getTestString(with, key: "title"),
                      subtitle: getTestString(with, key: "subtitle"),
                      authors: getTestString(with, key: "authors"),
                      publisher: getTestString(with, key: "publisher"),
                      isbn10: getTestString(with, key: "isbn10"),
                      isbn13: isbn13,
                      pages: getTestString(with, key: "pages"),
                      year: getTestString(with, key: "year"),
                      rating: getTestString(with, key: "rating"),
                      desc: getTestString(with, key: "desc"),
                      price: getTestString(with, key: "price"),
                      image: imageURL,
                      url: detailURL,
                      pdf: ["Chapter 5": pdfURL])
    }
            
    public static func getBookTotalDic(_ with: Int) -> [String: Any] {
        do {
            let dic = try getBookTotalDTO(with).encode()
            return dic
        }catch {
            return [:]
        }
    }
    
    public static func getTestString(_ with: Int, key: String) -> String{
        return "test_\(key)_\(with)"
    }
}
