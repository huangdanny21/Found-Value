//
//  GalleryView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI

struct GalleryView: View {
    var imageUrls: [String]

    var images: [UIImage]
    
    var showImages: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                if showImages {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                    }
                } else {
                    ForEach(imageUrls, id: \.self) { urlString in
                        if let url = URL(string: urlString) {
                            CachedImageView(url: url, imageCache: ImageCache.shared)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
