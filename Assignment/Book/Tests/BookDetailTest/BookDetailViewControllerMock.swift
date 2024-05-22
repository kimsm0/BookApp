/**
 @class BookDetailViewControllerMock
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
import Combine

@testable import BookDetail
class BookDetailViewControllerMock: UIViewController, BookDetailPresentable, BookDetailViewControllable {
    
    weak var interactor: BookDetailInteractableForPresenter?
    
    var updateCallCount = 0
    var showAlertCallCount = 0
    
    var book: BookDetailEntity?
    var imageKey: String?
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .defaultBg
    }
}

extension BookDetailViewControllerMock {
    func update(_ book: BookDetailEntity, 
                interactor: BookDetailInteractableForPresenter?
    ) {
        self.book = book
        updateCallCount += 1
        
        interactor?.loadImage(url: book.image)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
                self?.imageKey = output.1
                print("🟢🟢")
            }.store(in: &subscriptions)
        
        print("🟢🟢🟢")
    }
    
    func showAlert(message: String) {
        showAlertCallCount += 1
    }
    
    func showToast(message: String) {
        
    }
}


