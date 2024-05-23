/**
 @class API
 @date 05/21/24
 @writer kimsoomin
 @brief
 - UserDefaults에 저장된 값으로 서버 모드를 구분.
 - UITESTING 진행시에는 로컬 서버로 테스트 데이터 리턴하도록 한다. 
 @update history
 -
 */
import Foundation
import Storage

enum Server: String {
    case develop
    case staging
    case product
}

struct API {
    public init(){
        
    }
    public static var serverMode: Server {
        guard let mode = UserDefaultsStorage.server else { return .product }
        return Server(rawValue: mode) ?? .product
    }
    
    public var baseURL: String {
        #if UITESTING
        return "https://localhost:8080/"
        #else
        switch API.serverMode {
        case .develop:
            return "https://api.itbook.store/1.0/"
        case .staging:
            return "https://api.itbook.store/1.0/"
        case .product:
            return "https://api.itbook.store/1.0/"
        }
        #endif
    }
}


