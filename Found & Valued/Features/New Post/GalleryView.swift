//
//  GalleryView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI

struct GalleryView: View {
    var images: [UIImage]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
