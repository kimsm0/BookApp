/**
 @class DiskStorage
 @date 3/13/24
 @writer kimsoomin
 @brief
 -FileManager 를 이용한 Disk Cache 구현
 @update history
 -
 */
import UIKit
import CommonCrypto
import Extensions

public protocol DiskStorageType {
    func value(for key: String) throws -> UIImage?
    func store(for key: String, image: UIImage) throws
}

public final class DiskStorage: DiskStorageType {
    
    let fileManager: FileManager
    let directoryURL: URL

    public static let shared = DiskStorage()
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache")
        createDirectory()
    }
    
    func createDirectory(){
        if #available(iOS 16.0, *) {
            guard !fileManager.fileExists(atPath: directoryURL.path()) else {
                return
            }
        } else {
            // Fallback on earlier versions
        }
        do{
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func cacheFileURL(for key: String) -> URL {          
        let fileName = Data().sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    //key = url
    public func value(for key: String) throws -> UIImage? {

        let fileURL = cacheFileURL(for: key)
        if #available(iOS 16.0, *) {
            guard fileManager.fileExists(atPath: fileURL.path()) else {
                return nil
            }
        } else {
            // Fallback on earlier versions
        }
        
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
        
    }
    
    //url 이미지가 memory/disk 둘다 없는 경우.
    public func store(for key: String, image: UIImage) throws {
        let data = image.jpegData(compressionQuality: 0.5)
        let fileURL = cacheFileURL(for: key)
        try data?.write(to: fileURL)
    }
}

public class StubDiskStorage: DiskStorageType {
    public func value(for key: String) throws -> UIImage? {
        return nil
    }
    
    public func store(for key: String, image: UIImage) throws {
        
    }
}
