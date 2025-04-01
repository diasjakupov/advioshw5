//
//  CustomLayout.swift
//  advioshw5
//
//  Created by Dias Jakupov on 01.04.2025.
//

import SwiftUI


struct PinterestImageView: View {
    let image: ImageModel
    let width: CGFloat
    
    var body: some View {
        Group {
            if let uiImage = image.image {
                let height = uiImage.size.width > 0
                    ? width * (uiImage.size.height / uiImage.size.width)
                    : width
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
                    .overlay(
                        image.hasError ?
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 2) : nil
                    )
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: width, height: 150)
            }
        }
        .cornerRadius(8)
    }
}

struct PinterestGrid: View {
    let images: [ImageModel]
    let onReachedLastImage: () -> Void
    @State private var columnWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: 8) {
                LazyVStack(spacing: 8) {
                    ForEach(balancedColumns.left) { image in
                        NavigationLink(destination: DetailView(image: image.image)){
                            PinterestImageView(image: image, width: columnWidth)
                                .onAppear {
                                    if image.id == images.last?.id {
                                        onReachedLastImage()
                                    }
                                }
                        }
                        
                    }
                }
                
                LazyVStack(spacing: 8) {
                    ForEach(balancedColumns.right) { image in
                        NavigationLink(destination: DetailView(image: image.image)){
                            PinterestImageView(image: image, width: columnWidth)
                                .onAppear {
                                    if image.id == images.last?.id {
                                        onReachedLastImage()
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            
            GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    columnWidth = (geometry.size.width - 24) / 2
                                }
                        }
                        .frame(height: 0)
        }
    }
    
    var balancedColumns: (left: [ImageModel], right: [ImageModel]) {
        var leftColumn: [ImageModel] = []
        var rightColumn: [ImageModel] = []
        var leftHeight = 0
        var rightHeight = 0
        
        for image in images {
            if leftHeight <= rightHeight {
                leftColumn.append(image)
                leftHeight += image.height
            } else {
                rightColumn.append(image)
                rightHeight += image.height
            }
        }
        
        return (left: leftColumn, right: rightColumn)
    }
}


