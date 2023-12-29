//
//  FeedView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.feedItems) { feedItem in
                NavigationLink(destination: FeedItemDetailsView(feedItem: feedItem)) {
                    Section {
                        // Display the feed item content in a single section
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
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Public Feeds")
            .onAppear {
                viewModel.fetchPublicFeeds()
            }
        }
    }
}

