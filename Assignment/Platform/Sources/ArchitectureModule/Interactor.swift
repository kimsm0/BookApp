/**
 @class ViewModel
 @date
 @writer kimsoomin
 @brief
 - 비지니스 로직을 담당한다.
 - 상위 리블렛의 인터렉터로 접근 가능하다. (해당 리블렛의 detach를 진행하거나, 상위 리블렛의 진행되어야할 비지니스 로직이 있다면 parentInteractor 호출하여 진행한다.)
 - 현재 리블렛의 presentor를 생성 인자로 받는다.
 - Router를 통해 start가 호출되면 해당 리블렛의 라이프사이클이 진행된다.
 @update history
 -
 */

public protocol Interactable: AnyObject {
    func start()
}

open class Interactor<PresenterType>: Interactable {
        
    let presenter: PresenterType

    public init(presenter: PresenterType) {
        self.presenter = presenter
    }
    
    open func start() {
        
    }
}
