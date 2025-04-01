//
//  ImageRepository.swift
//  advioshw5
//
//  Created by Dias Jakupov on 01.04.2025.
//

protocol ImageRepositoryProtocol {
    func fetchImages(count: Int, completion: @escaping ([ImageModel]) -> Void)
}
