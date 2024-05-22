/**
 @class CustomError
 @date 5/20/24
 @writer kimsoomin
 @brief 공통으로 사용할 에러 타입 정의 
 @update history
 -
 */
import Foundation

public enum DecodingErrorType {
    case keyNotFound
    case valueNotFound
    case dataCorrupted
    case typeMismatch
    case etc
    
    public var customCode: String {
        switch self {
        case .keyNotFound:
            return "#DE-001"
        case .valueNotFound:
            return "#DE-002"
        case .dataCorrupted:
            return "#DE-003"
        case .typeMismatch:
            return "#DE-004"
        case .etc:
            return "#DE-005"
        }
    }
}
public enum NetworkError: Error, Equatable{
    case error(Error, Int?)
    case redirection //300번대
    case clientError //400번대
    case unauthorized //401 인증에러
    case serverError //500번대
    case invalidURL(String) //url 에러
    case decodingError(type: DecodingErrorType)
    
    public var customCode: String {
        switch self {
        case .error(_, let code):
            return "#NE-000 [\(code ?? 0)]"
        case .redirection:
            return "#NE-003"
        case .clientError:
            return "#NE-004"
        case .unauthorized:
            return "#NE-004-1"
        case .serverError:
            return "#NE-005"
        case .invalidURL(let url):
            printLog("invalidURL \(url)")
            return "#NE-000-1"
        case .decodingError(let type):
            return "\(type.customCode)"
        }
    }
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.customCode == rhs.customCode
    }
    
    static public func getErrorType(code: Int) -> Self {        
        if code >= 300 && code < 400 {
            return .redirection
        }else if  code >= 400 && code < 500{
            return .clientError
        }else if  code >= 500 && code < 600{
            return .serverError
        }else if  code == 401 {
            return.unauthorized
        }else if code == 998 {
            return .decodingError(type: .etc)
        }else if code == 999 {
            return .error(NSError(domain: "Not Found Status Code", code: code), code)
        }else {
            return .error(NSError(domain: "", code: code), code)
        }
    }
}


