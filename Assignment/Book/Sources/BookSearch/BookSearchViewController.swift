/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */

import UIKit
import Combine
import ArchitectureModule
import Extensions
import BookDataModel
import CustomUI
import Common

// MARK: ViewController에서 구현해야할 프로토콜
// Router -> ViewController
protocol BookSearchViewControllable: ViewControllable {
    
}

// Interator -> ViewController
protocol BookSearchPresentable: Presentable {
    var interactor: BookSearchInteractableForPresenter? { get set }
    func showAlert(message: String)
    func showToast(message: String)
    func update(_ with: [BookEntity])
    func reset()
}

class BookSearchViewController: UIViewController, BookSearchPresentable, BookSearchViewControllable {
    
    private var dataSource: [BookEntity] = []
    private var subscriptions = Set<AnyCancellable>()
    weak var interactor: BookSearchInteractableForPresenter?
        
    // MARK:UI
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookSearchCell.self,
                           forCellReuseIdentifier: "BookSearchCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "bookSearch_tableview"
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.isHidden = true
        return tableView
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "상단 검색필드를 이용하여 \n책을 검색해보세요."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .semibold16
        label.textColor = .defaultFont
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchView: SearchView = {
       let view = SearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .defaultBg
        self.setupNavigationItem(left: nil,
                                 right: nil,
                                 title: "책 검색")
        attribute()
        layout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func attribute(){
        tableView.dataSource = self
        tableView.delegate = self
        self.view.backgroundColor = .defaultBg
    }
    
    private func layout(){
        view.addSubview(guideLabel)
        view.addSubview(searchView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([    
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchView.heightAnchor.constraint(equalToConstant: 55),
            
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                        
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bind(){
        searchView.textField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] text in
                if text.isEmpty {
                    self?.showToast(message: "검색어를 입력해주세요.")                    
                }else {
                    self?.interactor?.searchBooks(text)
                }
            }.store(in: &subscriptions)                
    }
    
    func reset(){
        self.dataSource.removeAll()
        self.tableView.reloadData()
    }
    
    func update(_ with: [BookEntity]) {
        self.dataSource = with
        
        if dataSource.isEmpty {
            guideLabel.isHidden = false
            tableView.isHidden = true
            guideLabel.text = "검색 결과가 없습니다."
        }else {
            guideLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}

extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookSearchCell", for: indexPath) as? BookSearchCell
        cell?.config(book: dataSource[safe: indexPath.row], interator: interactor)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.didSelected(book: dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataSource.count - 2 == indexPath.row && searchView.hasText {
            interactor?.loadMore()
        }
    }
}
extension BookSearchViewController {
    func showAlert(message: String) {
        self.showAlert(message: message, confirmTitle: "확인")
    }
    func showToast(message: String) {
        Toast.showToast(message: message)
    }
}

