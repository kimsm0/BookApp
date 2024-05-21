/**
 @class ImageCacheService
 @date 5/21/24
 @writer kimsoomin
 @brief
 1. Memory Cache를 확인
 2. Disk Cache 확인 ( File Manager)
 3. URLSession request
 @update history
 -
 */
import UIKit
import Combine
import Storage

public protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<(UIImage?,String), Never>
}

public class ImageCacheService: ImageCacheServiceType{
    let memoryStorage: MemoryStorage
    let diskStorage: DiskStorage
    
    public init() {
        self.memoryStorage = MemoryStorage.shared
        self.diskStorage = DiskStorage.shared
    }
    
    public func image(for key: String) -> AnyPublisher<(UIImage?,String), Never> {
        
        imageFromMemoryStorage(for: key)
            .flatMap{ image -> AnyPublisher<(UIImage?,String), Never> in
                if let image {
                    return Just((image, key)).eraseToAnyPublisher()
                }else {
                    return self.imageFromDiskStorage(for: key)
                }
            }.eraseToAnyPublisher()
    }
    
    func imageFromMemoryStorage(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future{[weak self] promise in
            let image = self?.memoryStorage.value(for: key)
            promise(.success(image))
        }.eraseToAnyPublisher()
    }
    
    func imageFromDiskStorage(for key: String) -> AnyPublisher<(UIImage?,String), Never> {
        Future<UIImage?, Never> {[weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
            
        }.flatMap{ image -> AnyPublisher<(UIImage?,String), Never> in
            if let image {
                return Just((image, key))
                    .handleEvents(receiveOutput: {[weak self] output in
                        guard let image = output.0 else { return }
                        self?.store(for: key, image: image, toDisk: false)
                    }).eraseToAnyPublisher()
            }else{
                return self.requestImageURL(for: key)
            }
        }.eraseToAnyPublisher()
    }
    
    func requestImageURL(for urlString: String) -> AnyPublisher<(UIImage?, String), Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map{ data, _ in
                (UIImage(data: data), urlString)
            }.replaceError(with: (nil, urlString))
            .handleEvents(receiveOutput: {[weak self] output in
                guard let image = output.0 else { return }
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    func store(for key: String, image: UIImage, toDisk: Bool){
        memoryStorage.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

public class StubimageCacheService: ImageCacheServiceType {
    public func image(for key: String) -> AnyPublisher<(UIImage?,String), Never> {
        Empty().eraseToAnyPublisher()
    }
}

