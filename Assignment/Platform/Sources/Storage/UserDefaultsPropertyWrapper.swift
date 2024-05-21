/**
 @class UserDefaultsPropertyWrapper
 @date 5/20/24
 @writer kimsoomin
 @brief
 - UserDefaults 저장소 접근의 편의성을 위한 Wrapper 클래스 구현.
 @update history
 -
 */
import Foundation

@propertyWrapper
public struct UserDefaultsPropertyWrapper<T> {
    
    let key: String
    var defaultValue: T
    var storage: UserDefaults
    
    public var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key)}
    }
    
    public init(key: String, 
         defaultValue: T,
         storage: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}
