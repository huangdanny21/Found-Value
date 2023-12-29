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
            
            // Display details of the feed item
            if let url = URL(string: feedItem.imageURL) {
                CachedImageView(url: url, imageCache: ImageCache.shared)
            }
            Text("Item Title: \(feedItem.itemTitle)")
            Text("Item Description: \(feedItem.itemDescription)")


            // You can add more details here based on your FeedItem structure
        }
        .navigationBarTitle("Item Details") // Set the navigation bar title
    }
}
