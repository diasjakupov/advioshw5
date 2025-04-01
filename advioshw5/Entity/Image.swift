//
//  Image.swift
//  advioshw5
//
//  Created by Dias Jakupov on 01.04.2025.
//

import SwiftUI

struct ImageModel: Identifiable {
    let id = UUID()
    let image: UIImage?
    let hasError: Bool
    let height: Int
}
