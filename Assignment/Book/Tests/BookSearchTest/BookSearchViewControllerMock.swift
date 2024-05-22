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
import BookDataModel
import CustomUI

@testable import BookSearch
final class BookSearchViewControllerMock: UIViewController, BookSearchPresentable, BookSearchViewControllable {
    
    private var dataSource: [BookEntity] = []
    weak var interactor: BookSearchInteractableForPresenter?
        
    var updateCallCount = 0
    var showAlertCallCount = 0
    var resetCount = 0
    
    var dataCount: Int {
        dataSource.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .defaultBg
        self.setupNavigationItem(left: nil,
                                 right: nil,
                                 title: "책 검색")
        attribute()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func attribute(){
        self.view.backgroundColor = .defaultBg
    }
       
    func reset(){
        self.dataSource.removeAll()
        resetCount += 1
    }
    
    func update(_ with: [BookEntity]) {
        self.dataSource = with
        updateCallCount += 1
    }
}


extension BookSearchViewControllerMock {
    func showAlert(message: String) {
        showAlertCallCount += 1
    }
    func showToast(message: String) {
        
    }
}

