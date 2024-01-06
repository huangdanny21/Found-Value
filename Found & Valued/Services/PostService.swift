//
//  PostService.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/5/24.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct PostService {
    static func toggleLike(for postId: String, userId: String) async throws {
        let postRef = Firestore.firestore().collection("posts").document(postId)
        
        do {
            var post = try await postRef.getDocument(as: Post.self)
            if var likes = post.likes {
                if let user = likes.first(where: { $0.id == userId }) {
                    post.likes?.append(user)
                } else {
                    let simpleUser = SimpleUser(id: Auth.auth().currentUser?.uid ?? "", username: CurrentUser.shared.username ?? "", userProfilePic: Auth.auth().currentUser?.photoURL?.absoluteString)
                    likes.append(simpleUser)
                }
//                post["likes"] = likes
                try await postRef.updateData([
                    "likes": likes
                ])
                //                try await postRef.setData(from: post, completion: nil)
                print("Toggle like for post: \(postId)")
            } else {
                throw PostServiceError.postNotFound
            }
        } catch {
            print("Error toggling like for post: \(error.localizedDescription)")
            throw error
        }
    }

    enum PostServiceError: Error {
        case postNotFound
    }
}
