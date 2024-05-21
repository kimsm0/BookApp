/**
 @class BookDetailRequest
 @date 5/21/24
 @writer kimsoomin
 @brief
 -Book 상세 API 요청
 @update history
 -
 */
import Foundation
import Network
import BookDataModel
import Common

struct BookDetailRequest: Request {
    typealias Output = BookDetailDTO
    
    var endpoint: URL
    var method: HTTPMethod
    var query: QueryItems
    var header: HTTPHeader
    var isMultiPart: Bool
    
    init(baseURL: URL,
         id: String,
         isMultiPart: Bool? = false
    ){
        let getURL = APIPath.bookDetail + "/\(id)" 
        self.endpoint = baseURL.appendingPathComponent(getURL)
        self.method = .get
        self.isMultiPart = isMultiPart!
        self.query = [:]
        self.header = Constant.commonHeader
    }
}

