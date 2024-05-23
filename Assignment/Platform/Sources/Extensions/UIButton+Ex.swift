//
//  File.swift
//  
//
//  Created by kimsoomin_mac2022 on 5/23/24.
//

import UIKit

public extension UIButton {
    public func setDisabled()  {
        self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        self.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
    }
}
