//
//  GalleryViewModel.swift
//  advioshw5
//
//  Created by Dias Jakupov on 01.04.2025.
//

import SwiftUI

class GalleryViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var isLoading = false
    
    private let repository: ImageRepositoryProtocol
    private let imagesPerBatch = 10
    
    init(repository: ImageRepositoryProtocol = ImageRepository()) {
        self.repository = repository
    }
    
    func fetchImages() {
        guard !isLoading else { return }
        isLoading = true
        
        repository.fetchImages(count: imagesPerBatch) { [weak self] newImages in
            guard let self = self else { return }
            self.images.append(contentsOf: newImages)
            self.isLoading = false
        }
    }
    
    func refreshImages() {
        images.removeAll()
        fetchImages()
    }
}
