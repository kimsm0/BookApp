
import UIKit
import Combine
import Extensions
import BookDataModel
import Network
import CustomUI

final class BookSearchCell: UITableViewCell {
        
    private let bookImageView: CustomImageView = {
        let imgView = CustomImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.accessibilityIdentifier = "book_search_cell_image"
        imgView.translatesAutoresizingMaskIntoConstraints = false        
        return imgView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold14
        label.textColor = .defaultFont
        label.numberOfLines = 0
        label.accessibilityIdentifier = "book_search_cell_title"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .defaultFont
        label.numberOfLines = 0
        label.accessibilityIdentifier = "book_search_cell_subtitle"
        return label
    }()
    
    private let isbn13Label: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .defaultFont
        label.accessibilityIdentifier = "book_search_cell_isbn13"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .defaultFont
        label.accessibilityIdentifier = "book_search_cell_subtitle"
        return label
    }()
   
    private var subscriptions = Set<AnyCancellable>()
    
    private var id: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        titleLabel.text = nil
        subTitleLabel.text = nil
        isbn13Label.text = nil
        priceLabel.text = nil
        bookImageView.downloadImage = nil
    }
    
    func attribute(){
        self.selectionStyle = .none
        self.accessibilityIdentifier = "book_search_cell"
    }
    
    func layout(){
        contentView.addSubview(bookImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(isbn13Label)
        stackView.addArrangedSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bookImageView.widthAnchor.constraint(equalToConstant: 50),
            bookImageView.heightAnchor.constraint(equalToConstant: 50),
            bookImageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -16),
                        
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            subTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            isbn13Label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            isbn13Label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            isbn13Label.heightAnchor.constraint(equalToConstant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // Hugging Priority 설정
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        subTitleLabel.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)//수직으로 가능한 작게 유지
                
        // Compression Resistance Priority 설정
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)// 수직 방향에서 압축되지 않도록
        
        bookImageView.layoutUpdate()
    }
    
    func config(book: BookEntity?,
                interator: BookSearchInteractableForPresenter?
    ){
        guard let book else { return }
        id = book.image
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        isbn13Label.text = book.isbn13
        priceLabel.text = book.price
        
        interator?.loadImage(url: book.image)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
                if let id = self?.id, output.1 == id {
                    self?.bookImageView.downloadImage = output.0
                }
            }.store(in: &subscriptions)
    }
}
