/**
 @class
 @date
 @writer kimsoomin
 @brief
 @update history
 -
 */
import UIKit

public extension UIColor {
    static let bundleIdentifier = Bundle.module
    
    static let customYellow = UIColor.init(red: 250/255.0, green: 226/255.0, blue: 76/255.0, alpha: 1)
    static let notEnabledBg = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
    static let imageViewBg = UIColor.init(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
            
    static let defaultBg: UIColor = UIColor(named: "defaultBg", in: bundleIdentifier, compatibleWith: nil)!
    static let defaultShadow: UIColor = UIColor(named: "defaultShadow", in: bundleIdentifier, compatibleWith: nil)!
    
    static let defaultComponentBg: UIColor = UIColor(named: "defaultComponentBg", in: bundleIdentifier, compatibleWith: nil)!
    
    static let defaultFont: UIColor = UIColor(named: "defaultFont", in: bundleIdentifier, compatibleWith: nil)!
    
    
}
