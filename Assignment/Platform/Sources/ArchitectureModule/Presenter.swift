
import UIKit


public protocol Presentable: AnyObject { }

open class Presenter<PresenterType>: Presentable {
    
    var interactor: Interactable?
    
    public let viewController: PresenterType

    public init(viewController: PresenterType) {
        self.viewController = viewController
    }
}
