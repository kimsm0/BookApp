/**
 @class
 @date 5/20/24
 @writer kimsoomin
 @brief
 @update history
 -
 */

import UIKit
import Combine

extension UIControl {
    final class GestureSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control {
        
         var subscriber: S?
         let control: Control
        
        // MARK: Init
         init(subscriber: S,
             control: Control,
             event: UIControl.Event
        ) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action:#selector(eventHandler) , for: event)
        }        
        
        @objc
         func eventHandler(){
            _ = subscriber?.receive(control)
        }
        // MARK: Subscription Protocol Method
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {
            
        }
    }
}
public extension UIControl {
    final class GesturePublisher<Control: UIControl>: Publisher {
        
        public typealias Output = Control
        public typealias Failure = Never
        
        private let control: Control
        private let controlEvent: Control.Event
        
        // MARK: Init
        public init(control: Control,
             controlEvent: Control.Event
        ) {
            self.control = control
            self.controlEvent = controlEvent
        }
        // MARK: Publisher Protocol Method
        public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {            
            let subscription = GestureSubscription(subscriber: subscriber, control: control, event: controlEvent)
            subscriber.receive(subscription: subscription)
        }
    }
}

public extension UIControl {
    //자주 사용 되는 이벤트나 함수 들의 실행되는 빈도를 줄여서, 성능 상의 유리함을 가져오기 위한 개념이
    func throttleTapPublisher() -> Publishers.Throttle<UIControl.GesturePublisher<UIControl>, RunLoop> {
        
        return GesturePublisher(control: self, controlEvent: .touchUpInside)
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: false)
    }
    
    func firstTapPublisher() -> Publishers.First<UIControl.GesturePublisher<UIControl>> {
        return GesturePublisher(control: self, controlEvent: .touchUpInside)
            .first()
    }
    
    func shareTapPublisher2() -> Publishers.Share<UIControl.GesturePublisher<UIControl>> {
        return GesturePublisher(control: self, controlEvent: .touchUpInside)
            .share()
    }
}
