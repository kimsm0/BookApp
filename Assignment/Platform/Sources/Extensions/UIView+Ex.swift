/**
 @class UIView+Ex.swift
 @date 5/20/24
 @writer kimsoomin
 @brief
 - 그림자 효과를 추가하기 위한 공통 함수 정의 
 @update history
 -
 */
import UIKit

public extension UIView {
    enum ShadowLocation {
        case top
        case bottom
    }
    
    func addLineShadow(location: ShadowLocation, offset: CGSize? = .init(width: -10, height: -2.5), opacity: Float? = 0.25){
        self.layer.shadowColor = UIColor.defaultShadow.cgColor
        self.layer.shadowOpacity = opacity!
        switch location {
        case .top:
            self.layer.shadowOffset = offset!
            self.layer.shadowRadius = abs(offset!.height)
        case .bottom:
            self.layer.shadowOffset = CGSize.init(width: 10, height: 2.5)
            self.layer.shadowRadius = abs(offset!.height)
        }
    }
}
