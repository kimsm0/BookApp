/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */

import UIKit
import ArchitectureModule
import Extensions

// MARK: ViewController에서 구현해야할 프로토콜들
// Interator -> ViewController
protocol BookSearchViewControllable: ViewControllable {
    
}
// Router -> ViewController
protocol BookSearchPresentable: Presentable {
    var interactor: BookSearchInteractable? { get set }
}

class BookSearchViewController: UIViewController, BookSearchPresentable, BookSearchViewControllable {
    
    weak var interactor: BookSearchInteractable?
    
    override func viewDidLoad() {
        super.viewDidLoad()  
        self.view.backgroundColor = .blue
    }
}



