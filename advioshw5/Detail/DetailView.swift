//
//  DetailView.swift
//  advioshw5
//
//  Created by Dias Jakupov on 01.04.2025.
//

import SwiftUI

struct DetailView: View {
    let image: UIImage?
    
    var body: some View {
        Group {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .navigationTitle("Detail")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Image not available")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.black.opacity(0.05))
    }
}
