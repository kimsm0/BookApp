//
//  File.swift
//  newsApp
//
//  Created by kimsoomin_mac2022 on 5/21/24.
//

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


