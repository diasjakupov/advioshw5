//
//  GalleryView.swift
//  advioshw5
//
//  Created by Dias Jakupov on 01.04.2025.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    PinterestGrid(
                        images: viewModel.images,
                        onReachedLastImage: {
                            viewModel.fetchImages()
                        }
                    )
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
            .navigationTitle("Pinterest Gallery")
            .refreshable {
                viewModel.refreshImages()
            }
            .onAppear {
                if viewModel.images.isEmpty {
                    viewModel.fetchImages()
                }
            }
        }
    }
}
