/**
 @class ReadOnlyCurrentValuePublisher & CurrentValuePublisher
 @date 5/20/24
 @writer kimsoomin
 @brief
 - Send를 wrapping하여 구독만 가능하도록 custom한 publisher 
 @update history
 -
 */

import Foundation
import Combine

public class ReadOnlyCurrentValuePublisher<Element: Any>: Publisher {
    public typealias Output = Element
    public typealias Failure = Never
    
    public var value: Element? {
        currentValueSubject.value
    }
    
    fileprivate let currentValueSubject: CurrentValueSubject<Element, Never>
    fileprivate init(_ initialValue: Element){
        currentValueSubject = CurrentValueSubject(initialValue)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
        currentValueSubject.receive(subscriber: subscriber)
    }
}

public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
    public typealias Output = Element
    public typealias Failure = Never
    
    public override init(_ initialValue: Element){
        super.init(initialValue)
    }
    
    public func send(_ value: Element){
        currentValueSubject.send(value)
    }
}
