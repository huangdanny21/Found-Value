//
//  PostViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/5/24.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    func toggleLike(userId: String, username: String, profilePic: String) {
        if let likes = post.likes, likes.contains(where: { $0.id == userId }) {
            // Unlike post
            post.likedBy.removeAll(where: { $0.id == userId })
            // Remove the user's like in Firestore or perform relevant operations
            // Your Firestore update logic here
        } else {
            // Like post
            let likedUser = LikedByUser(id: userId, username: username, userProfilePic: profilePic)
            post.likedBy.append(likedUser)
            // Add the user's like in Firestore or perform relevant operations
            // Your Firestore update logic here
        }
        // Update UI after toggling like status
        objectWillChange.send()
    }
}
