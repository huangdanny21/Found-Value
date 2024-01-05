//
//  MyPostsView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import UIKit

struct MyPostsView: View {
    
    @StateObject private var myPostsViewModel = MyPostsViewModel()
    
    @State private var imageCache = ImageCache.shared
    var onlogout: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(myPostsViewModel.myPosts) { post in
                            VStack(alignment: .leading) {
                                GalleryView(imageUrls: post.imageUrls, images: [], showImages: false)
                                Text(post.content)
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("My Posts")
            .task {
                do {
                    await myPostsViewModel.fetchPosts()
                }
            }
        }
    }
}
