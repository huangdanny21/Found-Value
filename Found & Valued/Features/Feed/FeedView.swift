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
    
    let columns: [GridItem] = [
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
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150) // Adjust the height as needed
                                        .clipped()
                                }
                                Text(item.name)
                                    .font(.headline)
                                    .lineLimit(1) // Limit the lines to one for name
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2) // Limit the lines to two for description
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
                    viewModel.fetchUserPosts()
                }
            }
            .navigationTitle("Public Feeds")
            .navigationBarItems(trailing: NavigationLink(destination: SearchView(), label: {
                Image(systemName: "magnifyingglass")
            }))
        }
    }
}
