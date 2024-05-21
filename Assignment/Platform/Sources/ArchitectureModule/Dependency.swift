//
//  DependencyType.swift
//  Assignment
//
//  Created by kimsoomin_mac2022 on 5/20/24.
//

import Foundation

public protocol Dependency: AnyObject {}

public protocol EmptyDependency: Dependency {}

open class DependencyBox<DependencyType>: Dependency {

    let dependency: DependencyType
    
    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}


public class EmptyDependencyBox: EmptyDependency {
    public init() {}
}

