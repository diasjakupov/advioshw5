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
        let urlString = generateImageUrl(height: randomHeight)
        
        guard let url = URL(string: urlString) else {
            completion(createErrorImage(height: randomHeight))
            return
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(ImageModel(image: cachedImage, hasError: false, height: randomHeight))
            return
        }
        
        downloadImage(from: url, urlString: urlString, height: randomHeight, completion: completion)
    }
    
    private func generateImageUrl(height: Int) -> String {
        return "https://picsum.photos/\(imageSize)/\(height)?random=\(UUID().uuidString)"
    }
    
    private func downloadImage(from url: URL, urlString: String, height: Int, completion: @escaping (ImageModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: urlString as NSString)
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
