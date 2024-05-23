//
//  File.swift
//  
//
//  Created by kimsoomin_mac2022 on 5/23/24.
//

import WebKit

public final class CommonProcessPool {
    public static let instance = CommonProcessPool()
    let processPool = WKProcessPool()
    public func getProcessPool() -> WKProcessPool{
        return processPool
    }
}
