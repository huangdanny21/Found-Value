//
//  MyPostsService.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/5/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct MyPostsService {
    static func fetchPostsForCurrentUser() async throws -> [Post] {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw CommonError.noUser
        }

        let userDocument = Firestore.firestore().collection("users").document(currentUserID)

        do {
            let documentSnapshot = try await userDocument.getDocument()
            if let postData = documentSnapshot.data()?["posts"] as? [String] {
                let fetchedPosts = try await MyPostsService.fetchPosts(forPostIds: postData)

                return fetchedPosts
            } else {
                print("No post data found for the current user")
                return []
            }
        } catch {
            print("Error fetching posts for current user: \(error.localizedDescription)")
            throw error
        }
    }
    
    static func fetchPosts(forPostIds postIds: [String]) async throws -> [Post] {
        let postsCollection = Firestore.firestore().collection("posts")

        return try await withThrowingTaskGroup(of: Post.self, body: { group in
            for postID in postIds {
                group.addTask {
                    return try await postsCollection.document(postID).getDocument(as: Post.self)
                }
            }
            var fetchedPosts: [Post] = []
            for try await post in group {
                fetchedPosts.append(post)
            }
            return fetchedPosts
        })
    }
}
