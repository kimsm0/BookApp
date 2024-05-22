/**
 @class UIImageView+Ex.swift
 @date 5/20/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import UIKit

public final class CustomImageView: UIImageView {
        
    private let loadingView = UIActivityIndicatorView(style: .medium)
    
    public var downloadImage: UIImage? {
        didSet{
            self.image = downloadImage
            
            if downloadImage == nil {
                loadingView.startAnimating()
            }else {
                loadingView.stopAnimating()
            }
        }
    }
    
    public init(){
        super.init(frame: .zero)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func layoutUpdate(){
        self.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .defaultFont
        downloadImage = nil
    }
}

