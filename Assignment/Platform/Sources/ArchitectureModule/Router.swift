/**
 @class Coordinatorable
 @date
 @writer kimsoomin
 @brief
 - 리블렛간의 이동을 담당한다.
 - 생성자에서 현재 리블렛의 presentor(view) 와 interactor(business logic) 을 인자로 받는다.
 - presentor는 실제로 view를 화면에 노출할 때 사용하며, interactor은 하위 리블렛에서 상위 리블렛의(현재) interactor을 접근할 수 있게 하기 위해 받는다.
 - 현재 컴포넌트의 하위 리블렛을 관리하는 childers 배열이 있다.
 - attach/ detach 를 호출하여 하위 리블렛을 추가/제거한다.
 - attach를 통해 하위 리블렛을 추가할 때, 하위 리블렛의 interactor start 함수를 호출하여 해당 리블렛의 라이프 사이클을 시작한다.
 @update history
 -
 */

import Extensions

public protocol Routing: AnyObject {
    var viewController:  ViewControllable { get set }
    var interactor:  Interactable { get set }
    var childrens: [Routing] { get }
    
    func attach(child: Routing)
    func detach(child: Routing)
}

open class Router<InteractorType, PresenterType>: Routing {
    public var interactor:  Interactable
    public var viewController:  ViewControllable
        
    public var interactable:  InteractorType
    public var viewControllerable:  PresenterType
        
    public var childrens: [Routing] = []
    
    public init(interactor: InteractorType,
                viewController: PresenterType
    ){
        self.interactable = interactor
        self.viewControllerable = viewController
        
        guard let interactor = interactor as? Interactable,
            let viewController = viewControllerable as? ViewControllable
              
        else {
            fatalError("error")
        }
        self.interactor = interactor
        self.viewController = viewController
    }
    
    public func attach(child: Routing){
        childrens.append(child)
        child.interactor.start()
    }
    
    public func detach(child: Routing){
        childrens.removeElement(child)
    }
}
