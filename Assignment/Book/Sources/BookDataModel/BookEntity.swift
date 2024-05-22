/**
 @class BookEntity
 @date 5/21/24
 @writer kimsoomin
 @brief
 - Book리블렛들에서 사용되는 데이터 모델
 @update history
 -
 */

import Foundation

// MARK: - Total
public struct BookTotalEntity {
    public let total: Int
    public let page: Int
    public var books: [BookEntity]
    
    public init(total: Int,
                page: Int,
                books: [BookEntity]
    ) {
        self.total = total
        self.page = page
        self.books = books
    }
}


public struct BookEntity {
    public let title: String
    public let subtitle: String
    public let isbn13: String
    public let price: String
    public let image: String
    public let url: String
    
    public init(title: String,
                subtitle: String,
                isbn13: String,
                price: String,
                image: String,
                url: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isbn13 = isbn13
        self.price = price
        self.image = image
        self.url = url
    }
}

public struct BookDetailEntity {
    public let error: String
    public let title: String
    public let subtitle: String
    public let authors: String
    public let publisher: String
    public let isbn10: String
    public let isbn13: String
    public let pages: String
    public let year: String
    public let rating: String
    public let desc: String
    public let price: String
    public let image: String
    public let url: String
    public let pdf: PDFEntity?
    
    public init(error: String,
                title: String,
                subtitle: String,
                authors: String,
                publisher: String,
                isbn10: String,
                isbn13: String,
                pages: String,
                year: String,
                rating: String,
                desc: String,
                price: String,
                image: String,
                url: String,
                pdf: [String: String]?
                
    ) {
        self.error = error
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.publisher = publisher
        self.isbn10 = isbn10
        self.isbn13 = isbn13
        self.pages = pages
        self.year = year
        self.rating = rating
        self.desc = desc
        self.price = price
        self.image = image
        self.url = url
        self.pdf = PDFEntity(pdf: pdf)
    }
    

    public static func initEntity() -> BookDetailEntity {
        return .init(error: "", title: "", subtitle: "", authors: "", publisher: "", isbn10: "", isbn13: "", pages: "", year: "", rating: "", desc: "", price: "", image: "", url: "", pdf: [:])
    }
}

public struct PDFEntity {
    public let pdf: [String: String]?
    
    public var chapter2: String{
        pdf?["Chapter 2"] ?? ""
    }
    public var chapter5: String{
        pdf?["Chapter 5"] ?? ""
    }
    
    public init(pdf: [String: String]?){
        self.pdf = pdf
    }
}
