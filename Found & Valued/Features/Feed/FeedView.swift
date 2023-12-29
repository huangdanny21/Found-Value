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
            VStack {
                // Display fetched public feed items
                List(viewModel.feedItems) { feedItem in
                    // Display feed item details
                    // Example:
                    VStack(alignment: .leading) {
                        Text(feedItem.itemTitle)
                            .font(.headline)
                        Text(feedItem.itemDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        // Add image display or other content here using the imageURL
                    }
                }
            }
            .navigationTitle("Public Feeds")
            .onAppear {
                viewModel.fetchPublicFeeds() // Fetch public feeds when the view appears
            }
        }
    }
}

