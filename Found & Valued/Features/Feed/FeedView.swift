//
//  FeedView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()

    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(viewModel.feedItems) { feedItem in
                        // Display feed item content in each grid cell
                        // Adjust the content as per your FeedItem structure
                        VStack {
                            
                            if let imageURL = URL(string: feedItem.imageURL) {
                                // Load and display the image using URLSession or your preferred library
                                CachedImageView(url: imageURL, imageCache: ImageCache.shared)
                            }
                            
                            Text(feedItem.itemTitle)
                                .font(.headline)
                            Text(feedItem.itemDescription)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            // Add image display or other content here using the imageURL
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(8)
            }
            .navigationTitle("Public Feeds")
            .onAppear {
                viewModel.fetchPublicFeeds()
            }
        }
    }
}
