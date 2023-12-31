//
//  FeedView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.items) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            VStack(alignment: .leading) {
                                if let imageURL = item.imageURL {
                                    CachedImageView(url: imageURL, imageCache: ImageCache.shared)
                                }
                                Text(item.name)
                                    .font(.headline)
                                Text(item.description)
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .onAppear {
                    viewModel.fetchPublicFeeds()
                }
            }
            .navigationTitle("Public Feeds")
            .navigationBarItems(trailing: NavigationLink(destination: SearchView(), label: {
                Image(systemName: "magnifyingglass")
            }))
        }
    }
}
