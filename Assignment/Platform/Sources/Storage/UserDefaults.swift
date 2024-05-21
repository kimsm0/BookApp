/**
 @class UserDefaultsStorage
 @date 5/20/24
 @writer kimsoomin
 @brief
 - UserDefaults 저장소
 @update history
 -
 */
import Foundation

public final class UserDefaultsStorage: NSObject {
    
    // MARK: - Properties
    @UserDefaultsPropertyWrapper(key: "kimsoomin.assignment.server", defaultValue: nil)
    public static var server: String?
        
}
