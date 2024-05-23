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
import PDFKit

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
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let detailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "bookdetail_imageview"
        return imageView
    }()
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultFont
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold25
        label.textColor = .defaultFont
        label.numberOfLines = 0
        label.accessibilityIdentifier = "bookdetail_title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        label.textColor = .defaultFont
        label.numberOfLines = 0
        label.accessibilityIdentifier = "bookdetail_subtitle"
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
        label.textColor = .defaultFont
        label.numberOfLines = 0
        label.accessibilityIdentifier = "bookdetail_author"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publisherYearPageLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.textColor = .defaultFont
        label.numberOfLines = 0
        label.accessibilityIdentifier = "bookdetail_publisher"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultFont
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.textColor = .defaultFont
        label.numberOfLines = 0
        label.accessibilityIdentifier = "bookdetail_desc"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isbnLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .defaultFont
        label.numberOfLines = 2
        label.accessibilityIdentifier = "bookdetail_isbn"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .defaultFont
        label.numberOfLines = 2
        label.accessibilityIdentifier = "bookdetail_price"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.displayDirection = .horizontal
        pdfView.autoScales = false
        pdfView.displayMode = .singlePageContinuous
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
            
    private let pdfButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("PDF보러가기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 6
        btn.accessibilityIdentifier = "bookdetail_pdf_button"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let detailButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("더보기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityIdentifier = "bookdetail_detail_button"
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
        view.addSubview(topLineView)
        view.addSubview(scrollView)
        view.addSubview(pdfButton)
        view.addSubview(detailButton)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(detailImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(ratingView)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(publisherYearPageLabel)
        stackView.addArrangedSubview(lineView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(isbnLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.setCustomSpacing(14, after: priceLabel)
        stackView.addArrangedSubview(pdfView)
        
        NSLayoutConstraint.activate([
            
            detailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailButton.heightAnchor.constraint(equalToConstant: 45),
            
            pdfButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pdfButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pdfButton.bottomAnchor.constraint(equalTo: detailButton.topAnchor, constant: -10),
            pdfButton.heightAnchor.constraint(equalToConstant: 45),
                
            topLineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topLineView.heightAnchor.constraint(equalToConstant: 1),
            
            scrollView.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 4),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: pdfButton.topAnchor, constant: -10),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            detailImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            detailImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
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
            
            lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            isbnLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            isbnLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            pdfView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            pdfView.heightAnchor.constraint(equalToConstant: 180),
        ])
       
        detailImageView.layoutUpdate()
    }
    
    func attribute(){
        self.view.backgroundColor = .defaultBg
    }
        
    func bind(){
        pdfButton.throttleTapPublisher()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.interactor?.didTapPdfButton()
            }.store(in: &subscriptions)
        
        detailButton.throttleTapPublisher()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.interactor?.didTapDetailButton()
            }.store(in: &subscriptions)
    }
}

extension BookDetailViewController {
    func update(_ book: BookDetailEntity, interactor: BookDetailInteractableForPresenter?) {
        interactor?.loadImage(url: book.image)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
                self?.detailImageView.downloadImage = output.0
            }.store(in: &subscriptions)
        
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        ratingView.setScore(Float(book.rating) ?? 0.0)
        authorLabel.text = book.authors
        publisherYearPageLabel.text = "\(book.publisher) / YEAR: \(book.year) / PAGE: \(book.pages)"
        descriptionLabel.text = book.desc
        isbnLabel.text = "\(book.isbn10) / \(book.isbn13)"
        priceLabel.text = book.price
                
        if !book.pdf.chapter5.isEmpty,  let url = URL(string: book.pdf.chapter5) {
            pdfLoad(pdfURL: url)
        }else if !book.pdf.chapter2.isEmpty,  let url = URL(string: book.pdf.chapter2) {
            pdfLoad(pdfURL: url)
        }else {
            pdfView.isHidden = true
            pdfButton.setTitle("지원되는 PDF가 없습니다.", for: .normal)
            pdfButton.setDisabled()
        }
    }
    
    func pdfLoad(pdfURL: URL){
        if let document = PDFDocument(url: pdfURL) {
            self.pdfView.document = document
            pdfView.scaleFactor = 0.1
        }
    }
}

extension BookDetailViewController {
    func showAlert(message: String) {
        showAlert(message: message, confirmTitle: "확인")
    }
    
    func showToast(message: String) {
        Toast.showToast(message: message)
    }
}
