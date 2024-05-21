
import UIKit
import Combine
import Extensions
import BookDataModel
import Network

final class BookSearchCell: UITableViewCell {
        
    private let bookImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.accessibilityIdentifier = "book_search_cell_image"
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "photo")
        return imgView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
    
    private let subTitle: UILabel = {
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
        label.numberOfLines = 0
        label.accessibilityIdentifier = "book_search_cell_isbn13"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular12
        label.textColor = .defaultFont
        label.numberOfLines = 0
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
        subTitle.text = nil
        isbn13Label.text = nil
        priceLabel.text = nil
        bookImageView.image = nil
    }
    
    func attribute(){
        self.selectionStyle = .none
        self.accessibilityIdentifier = "book_search_cell"
    }
    
    func layout(){
        contentView.addSubview(bookImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitle)
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
            
            subTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            isbn13Label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            isbn13Label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    func config(book: BookEntity, 
                interator: BookSearchInteractableForPresenter?
    ){
        id = book.image
        titleLabel.text = book.title
        subTitle.text = book.subtitle
        isbn13Label.text = book.isbn13
        priceLabel.text = book.price
        
        interator?.loadImage(url: book.image)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] output in
                if let id = self?.id, output.1 == id {
                    self?.bookImageView.image = output.0
                }
            }.store(in: &subscriptions)
    }
}
