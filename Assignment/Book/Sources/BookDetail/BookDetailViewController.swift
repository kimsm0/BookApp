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

// MARK: ViewController에서 구현해야할 프로토콜들
// Router -> ViewController
protocol BookDetailViewControllable: ViewControllable {
    
}

// Interator -> ViewController
protocol BookDetailPresentable: Presentable {
    var interactor: BookDetailInteractableForPresenter? { get set }
    func update(_ book: BookDetailEntity, interactor: BookDetailInteractableForPresenter?)
    func showAlert(message: String)
    func showToast(message: String)
}

class BookDetailViewController: UIViewController, BookDetailPresentable, BookDetailViewControllable {
    
    weak var interactor: BookDetailInteractableForPresenter?
    private var subscriptions = Set<AnyCancellable>()
    // MARK:UI
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold25
        label.numberOfLines = 0
        label.accessibilityIdentifier = "newsdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        label.numberOfLines = 0
        label.accessibilityIdentifier = "newsdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let ratingView: RatingView = {
        let view = RatingView(totalScore: 5, size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.numberOfLines = 0
        label.accessibilityIdentifier = "newsdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publisherYearPageLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.numberOfLines = 0
        label.accessibilityIdentifier = "newsdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultFont
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.numberOfLines = 0
        label.accessibilityIdentifier = "newsdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isbnLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.numberOfLines = 2
        label.accessibilityIdentifier = "newsdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.numberOfLines = 2
        label.accessibilityIdentifier = "newsdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
            
    private let pdfButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("PDF보러가기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        self.view.backgroundColor = .defaultBg
        self.setupNavigationItem(left: .dismiss(.back, self, #selector(didTapBackButton)),
                                 right: nil,
                                 title: "책 상세")
        
        layout()
        attribute()
        bind()
    }

    @objc
    private func didTapBackButton() {
        interactor?.didTapBackButton()
    }
    
    func layout(){        
        view.addSubview(scrollView)
        view.addSubview(pdfButton)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(detailImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(ratingView)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(publisherYearPageLabel)
        stackView.addArrangedSubview(topLineView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(isbnLabel)
        stackView.addArrangedSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            pdfButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pdfButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pdfButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pdfButton.heightAnchor.constraint(equalToConstant: 45),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: pdfButton.topAnchor, constant: -10),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),            
            
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            ratingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 20),
            
            authorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            publisherYearPageLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            publisherYearPageLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            topLineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            isbnLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            isbnLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    func attribute(){
        
    }
    
    func bind(){
        
    }
}

extension BookDetailViewController {
    func update(_ book: BookDetailEntity, interactor: BookDetailInteractableForPresenter?) {
        interactor?.loadImage(url: book.image)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
                self?.detailImageView.image = output.0
            }.store(in: &subscriptions)
        
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        ratingView.setScore(for:(Int(book.rating) ?? 0))
        authorLabel.text = book.authors
        publisherYearPageLabel.text = "\(book.publisher) / \(book.year) / \(book.pages)"
        descriptionLabel.text = book.desc
        isbnLabel.text = "\(book.isbn10) / \(book.isbn13)"
        priceLabel.text = book.price
        
    }
    
    func showAlert(message: String) {
        self.showAlert(message: message, confirmTitle: "확인")
    }
    
    func showToast(message: String) {
        Toast.showToast(message: message)
    }
}


