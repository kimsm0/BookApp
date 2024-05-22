
import Foundation
import BookTestSupport

typealias Path = String
typealias MockResponse = (statusCode: Int, data: Data?)

final class AppURLProtocol: URLProtocol {
    
    static var successMock: [Path: MockResponse] = [:]
    static var failureErros: [Path: Error] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        var path = request.url?.path ?? ""
        if !path.isEmpty {            
            if let mockResponse = AppURLProtocol.successMock[path] {
                client?.urlProtocol(self,
                                    didReceive: HTTPURLResponse(
                                        url: request.url!,
                                        statusCode: mockResponse.statusCode,
                                        httpVersion: nil,
                                        headerFields: nil)!,
                                    cacheStoragePolicy: .notAllowed)
                mockResponse.data.map { client?.urlProtocol(self, didLoad: $0)}
            }else if let error = AppURLProtocol.failureErros[path] {
                client?.urlProtocol(self, didFailWithError: error)
            }else {
                client?.urlProtocol(self, didFailWithError: MockSessionError.notSupported)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }    
}

enum MockSessionError: Error {
    case notSupported
}

// TODO:
func setupURLProtocol(){
    let bookTotal = BookTestDouble.getBookTotalDic(1)
    let bookTotalData = try! JSONSerialization.data(withJSONObject: bookTotal, options: [])
    
    let bookDetail = BookTestDouble.getBookDetailDic(1)
    let bookDetailData = try! JSONSerialization.data(withJSONObject: bookDetail, options: [])
    
    //https://api.itbook.store/1.0/
    AppURLProtocol.successMock = [
        "/1.0/search/\(BookTestDouble.searchKeyword)/1": (200, bookTotalData),
        "/1.0/books/\(BookTestDouble.isbn13)": (200, bookDetailData),
        "/books/\(BookTestDouble.isbn13)": (200, bookDetailData),
    ]
}
