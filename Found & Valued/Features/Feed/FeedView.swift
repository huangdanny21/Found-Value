//
//  FeedView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.feedItems) { feedItem in
                        NavigationLink(destination: FeedItemDetailsView(feedItem: feedItem)) {
                            VStack {
                                if let imageURL = URL(string: feedItem.imageURL) {
                                    CachedImageView(url: imageURL, imageCache: ImageCache.shared)
                                        .frame(maxHeight: 200)
                                        .cornerRadius(8)
                                        .aspectRatio(contentMode: .fit)
                                }
                                Text(feedItem.itemTitle)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                Text(feedItem.itemDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle()) // Use this to remove navigation link button style
                    }
                }
                .padding()
            }
            .navigationTitle("Public Feeds")
            .onAppear {
                viewModel.fetchPublicFeeds()
            }
        }
    }
}
