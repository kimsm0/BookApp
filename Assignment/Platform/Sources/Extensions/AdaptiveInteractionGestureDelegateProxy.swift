/**
 @class AdaptiveInteractionGestureDelegateProxy
 @date 5/6/24
 @writer kimsoomin
 @brief
 - Pop Gesture를 공통으로 Router에서 관리할 수 있도록 한다.
 - viewcontroller swipe pop gesture를 catch하여 delegate로 전달한다.
 @update history
 -
 */
import UIKit

//delegate로 사용할거라, weak으로 선언 = anyobject
public protocol AdaptiveInteractionGestureDelegate: AnyObject {
    func detactedInteractionGuesture()
}

public final class AdaptiveInteractionGestureDelegateProxy: NSObject, UIGestureRecognizerDelegate {
    
    public weak var delegate: AdaptiveInteractionGestureDelegate?
    public weak var viewController: ViewControllable?
    
    public init(viewController: ViewControllable?) {
        self.viewController = viewController
        
        super.init()
        self.viewController?.uiviewController.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.viewController?.uiviewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.viewController?.uiviewController.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGuesture))
    }
    
    @objc func handlePopGuesture(){
        delegate?.detactedInteractionGuesture()
    }
}
