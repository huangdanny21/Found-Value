//
//  ItemDetailsView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI

struct ItemDetailView: View {
    let item: Item
    @StateObject var itemDetailsViewModel = ItemDetailsViewModel()

    var body: some View {
        VStack {
            // Display item details
            Text("Item Title: \(item.name)")
                .padding()
            Text("Item Description: \(item.description)")
                .padding()

            // Show item image if available
            if let imageURL = item.imageURL {
                // Replace with your image loading logic (e.g., URLImage, AsyncImage)
                CachedImageView(url: imageURL, imageCache: ImageCache.shared)
            }

            Spacer()
            
            // Display comment section
            CommentSectionView(item: item, itemDetailsViewModel: itemDetailsViewModel)
                .padding()
        }
        .navigationBarTitle("Item Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            itemDetailsViewModel.fetchComments(for: item.id ?? "")
        }
    }
}
