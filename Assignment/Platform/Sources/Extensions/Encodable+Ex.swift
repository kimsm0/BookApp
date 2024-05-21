/**
 @class
 @date 5/20/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import Foundation

public extension Encodable {
    func encode() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)        
        guard let dic = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError()
        }
        return dic
    }
}
