//
//  PostView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/5/24.
//

import SwiftUI

struct PostView: View {
    @State var post: Post
    
    var body: some View {
        VStack {
            Text(post.content)
//            Button(action: {
//                toggleLike(for: post, userId: "currentUserId", username: "currentUserUsername", profilePic: "profilePicURL")
//            }) {
//                if post.likedBy.contains { $0.id == "currentUserId" } {
//                    Image(systemName: "heart.fill")
//                } else {
//                    Image(systemName: "heart")
//                }
//            }
        }
    }
}
