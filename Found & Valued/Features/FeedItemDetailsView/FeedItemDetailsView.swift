//
//  FeedItemDetailsView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct FeedItemDetailsView: View {
    let feedItem: FeedItem // Assuming FeedItem is a struct that conforms to Identifiable

    var body: some View {
        VStack {
            Spacer() // Pushes the content to the top
            
            // Display the image centered in the view
            if let url = URL(string: feedItem.imageURL) {
                CachedImageView(url: url, imageCache: ImageCache.shared)
                    .frame(maxWidth: .infinity) // Expand the image to the width of the screen
                    .padding()
            }

            Text("Item Title: \(feedItem.itemTitle)")
                .padding()
            Text("Item Description: \(feedItem.itemDescription)")
                .padding()

            Spacer() // Pushes the content to the bottom
        }
        .navigationBarTitle("Item Details") // Set the navigation bar title
        .navigationBarTitleDisplayMode(.inline) // Display the title in the middle of the navigation bar
    }
}
