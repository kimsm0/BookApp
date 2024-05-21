import UIKit

public final class RatingView: UIView {

    private let activeStarImage = UIImage(systemName: "star.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    private let halfStarImage = UIImage(systemName: "star.leadinghalf.filled")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    private let inactiveStarImage = UIImage(systemName: "star")?.withTintColor(.black, renderingMode: .alwaysOriginal)

    private let total: Int
    private let size: Int
    
    private var starImageViews: [UIImageView] = []
    
    required init?(coder: NSCoder) {
        self.total = 5
        self.size = 20
        super.init(coder: coder)
        setup()
    }
    
    public init(totalScore: Int, size: Int){
        self.total = totalScore
        self.size = size
        super.init(frame: .zero)
        setup()
        self.isHidden = true
    }

    private func setup() {
        for i in 0..<total{
            let size = CGSize.init(width: size, height: size)
            let star = UIImageView(frame: .init(origin: .init(x: i * Int(size.height), y: 0), 
                                                size: size))
            star.image = inactiveStarImage
            star.tag = i
            starImageViews.append(star)
            self.addSubview(star)
        }
    }

    public func setScore(for stars: Int) {
        self.isHidden = false
        for (index,view) in starImageViews.enumerated() {
            if index <= stars / 2 {
                view.image = activeStarImage
            } else {
                if (2 * index - stars) <= 1 {
                    view.image = halfStarImage
                } else {
                    view.image = inactiveStarImage
                }
            }
        }            
    }
}
