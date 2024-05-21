/**
 @class BookSearhRequest
 @date 5/21/24
 @writer kimsoomin
 @brief
 -Book 검색 API 요청
 @update history
 -
 */
import Foundation
import Network
import BookDataModel
import Common

struct BookSearhRequest: Request {
    typealias Output = BookTotalDTO
    
    var endpoint: URL
    var method: HTTPMethod
    var query: QueryItems
    var header: HTTPHeader
    var isMultiPart: Bool
    
    init(baseURL: URL,
         curPage: Int,
         query: String,
         isMultiPart: Bool? = false
    ){
        let getURL = APIPath.bookSearch + "/\(query)" + "/\(curPage)"
        self.endpoint = baseURL.appendingPathComponent(getURL)
        self.method = .get
        self.isMultiPart = isMultiPart!
        self.query = [:]
        self.header = Constant.commonHeader
    }
}

