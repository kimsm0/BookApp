/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */

import Foundation
import ArchitectureModule
import Extensions
import BookDetail

// MARK: Router에서 구현해야할 프로토콜
protocol BookSearchRouting: Routing {
    func attachBookDetail(id: String)
    func detachBookDetail()
}

class BookSearchRouter: Router<BookSearchInteractable, BookSearchViewControllable>,
                        AdaptiveInteractionGestureDelegate{
    
    private var bookDetailBuildable: BookDetailBuildable
    private var bookDetailRouting: Routing?
    
    private var interactionGuestureProxy: AdaptiveInteractionGestureDelegateProxy?
        
    init(interactor: BookSearchInteractable,
         viewController: BookSearchViewControllable,
         bookDetailBuildable: BookDetailBuildable
    ) {
        self.bookDetailBuildable = bookDetailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func detactedInteractionGuesture() {
        if let router = bookDetailRouting {
            detach(child: router)
            bookDetailRouting = nil
        }        
    }
}

extension BookSearchRouter: BookSearchRouting {
    func attachBookDetail(id: String) {
        if bookDetailRouting == nil {
            self.interactionGuestureProxy = AdaptiveInteractionGestureDelegateProxy(viewController: viewController)
            self.interactionGuestureProxy?.delegate = self
            
            let router = bookDetailBuildable.build(parentInteractor: interactable, bookId: id)
            bookDetailRouting = router
                              
            DispatchQueue.main.async {
                self.viewController.uiviewController.navigationController?.pushViewController(router.viewController.uiviewController, animated: true)
            }            
    
            attach(child: router)
        }
    }
    
    func detachBookDetail() {
        if let router = bookDetailRouting {
            viewController.uiviewController.navigationController?.popViewController(animated: true)
            detach(child: router)
            bookDetailRouting = nil
        }
    }
}


