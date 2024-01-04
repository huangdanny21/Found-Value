//
//  MyPostsView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI
import FirebaseAuth

struct MyPostsView: View {
    @StateObject var myPostsViewModel = MyPostsViewModel()

    var body: some View {
        NavigationView {
            if myPostsViewModel.posts.isEmpty {
                Text("You have no posts")
                    .padding()
            } else {
                List(myPostsViewModel.posts, id: \.id) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        VStack(alignment: .leading) {
                            Text(post.item.name)
                                .font(.headline)
                            Text(post.item.description)
                                .font(.subheadline)
                            
                            CommentSectionView(item: post.item, itemDetailsViewModel: ItemDetailsViewModel())
                                .onAppear {
                                    // Fetch comments for this specific post
                                    ItemDetailsViewModel().fetchComments(for: post.item.id ?? "")
                                }
                        }
                        .padding()
                    }
                }
                .navigationBarTitle("My Posts")
                .onAppear {
                    if let uid = Auth.auth().currentUser?.uid  {
                        self.myPostsViewModel.fetchMyPosts()
                    }
                }
            }
        }
    }
}
