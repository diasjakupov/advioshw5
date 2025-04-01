//
//  DefaultImageRepository.swift
//  advioshw5
//
//  Created by Dias Jakupov on 01.04.2025.
//

import SwiftUI


class ImageRepository: ImageRepositoryProtocol {
    private let imageCache = NSCache<NSString, UIImage>()
    private let imageSize = 200
    
    func fetchImages(count: Int, completion: @escaping ([ImageModel]) -> Void) {
        let group = DispatchGroup()
        var fetchedImages = [ImageModel]()
        let lock = NSLock()
        
        for _ in 0..<count {
            group.enter()
            fetchImage { image in
                lock.lock()
                fetchedImages.append(image)
                lock.unlock()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(fetchedImages)
        }
    }
    
    private func fetchImage(completion: @escaping (ImageModel) -> Void) {
        let randomHeight = Int.random(in: 150...300)
        let id = Int.random(in: 1...30)
        let urlString = generateImageUrl(id: id, height: randomHeight)
        
        guard let url = URL(string: urlString) else {
            completion(createErrorImage(height: randomHeight))
            return
        }
        
        
        if let cachedImage = imageCache.object(forKey: id.description as NSString) {
            
            print("cached image: \(id) \(url)")
            
            completion(ImageModel(image: cachedImage, hasError: false, height: randomHeight))
            return
        }
        
        downloadImage(from: url, id: id, height: randomHeight, completion: completion)
    }
    
    private func generateImageUrl(id: Int, height: Int) -> String {
        return "https://picsum.photos/id/\(id)/\(imageSize)/\(height)"
    }
    
    private func downloadImage(from url: URL, id: Int, height: Int, completion: @escaping (ImageModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: id.description as NSString)
                completion(ImageModel(image: image, hasError: false, height: height))
            } else {
                completion(self.createErrorImage(height: height))
            }
        }
    }
    
    private func createErrorImage(height: Int) -> ImageModel {
        return ImageModel(
            image: UIImage(systemName: "exclamationmark.triangle"),
            hasError: true,
            height: height
        )
    }
}
