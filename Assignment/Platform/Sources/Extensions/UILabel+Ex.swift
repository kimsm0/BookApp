//
//  File.swift
//  
//
//  Created by kimsoomin_mac2022 on 5/20/24.
//

import UIKit

public struct AttributeTextStyle {
    let font: UIFont
    let hasUnderline: Bool
    let targetText: String
    let lineSpacing: CGFloat
    
    public init(font: UIFont, 
                hasUnderline: Bool,
                targetText: String,
                lineSpacing: CGFloat
    ) {
        self.font = font
        self.hasUnderline = hasUnderline
        self.targetText = targetText
        self.lineSpacing = lineSpacing
    }
}

public extension UILabel {
    func setAttributeText(style: AttributeTextStyle){
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: style.targetText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: style.font, range: range)
        
        if style.hasUnderline {
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue , range: range)
        }
        
        if style.lineSpacing > 0 {
            paragraphStyle.lineSpacing = style.lineSpacing
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: (fullText as NSString).range(of: fullText))
        }
        
        self.attributedText = attributedString
    }
    
    func setLineSpacing(lineSpacing: CGFloat) {
        
    }
}
