/**
 @class BookDTO
 @date 5/21/24
 @writer kimsoomin
 @brief
 - Book리블렛들에서 사용되는 데이터 모델
 @update history
 -
 */
import Foundation

// MARK: - Total
public struct BookTotalDTO: Codable {
    public let total: String
    public let page: String
    public var books: [BookDTO]
    
    public init(total: String?,
                page: String?,
                books: [BookDTO]?
    ) {
        self.total = total ?? "0"
        self.page = page ?? "0"
        self.books = books ?? []
    }
    
    public func toEntity() -> BookTotalEntity {        
        .init(total: Int(self.total) ?? 0,
              page: Int(self.page) ?? 0,
              books: self.books.map{ $0.toEntity() })
    }
}


public struct BookDTO: Codable {
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
    ){
        self.title = title
        self.subtitle = subtitle
        self.isbn13 = isbn13
        self.price = price
        self.image = image
        self.url = url
    }
    
    public func toEntity() -> BookEntity {
        .init(title: self.title,
              subtitle: self.subtitle,
              isbn13: self.isbn13,
              price: self.price,
              image: self.image,
              url: self.url)
    }
}

public struct BookDetailDTO: Codable {
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
    public let pdf: [String: String]?
    
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
        self.pdf = pdf
    }
    public func toEntity() -> BookDetailEntity {
        .init(error: self.error,
              title: self.title,
              subtitle: self.subtitle,
              authors: self.authors,
              publisher: self.publisher,
              isbn10: self.isbn10,
              isbn13: self.isbn13,
              pages: self.pages,
              year: self.year,
              rating: self.rating,
              desc: self.desc,
              price: self.price,
              image: self.image,
              url: self.url,
              pdf: self.pdf
        )
    }
}

