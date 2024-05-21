/**
 @class MemoryStorage
 @date 5/21/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation
import UIKit

public protocol MemoryStorageType {
    func value(for key: String) -> UIImage? //get
    func store(for key: String, image: UIImage) //set
    func clear()
}

public final class MemoryStorage: MemoryStorageType {
    public static let shared = MemoryStorage()
    
    var cache = NSCache<NSString, UIImage>()
    
    public func value(for key: String) ->  UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    public func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
    public func clear(){
        cache.removeAllObjects()
    }
}

public class StubMemoryStorage: MemoryStorageType {
    public func value(for key: String) -> UIImage? {
        return nil
    }
    
    public func store(for key: String, image: UIImage) {
        
    }
    
    public func clear(){
        
    }
}
