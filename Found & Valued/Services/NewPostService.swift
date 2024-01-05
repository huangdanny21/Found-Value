//
//  NewPostService.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct NewPostService {
    static func createPost(with images: [UIImage], post: Post) async throws -> Post {
        do {
            let urls = try await storeImages(images: images)
             let post = try await self.createNewPost(withImageUrls: urls, post: post)
            return post
        } catch {
            print("Cannot create post: \(error.localizedDescription)")
            throw error
        }
    }
    
    static func storeImages(images: [UIImage]) async throws -> [URL] {
        do {
            let urls = try await ImageStorageService.uploadAsJPEG(images: images, path: "postImages")
            return urls
        } catch {
            print("Error uploading image: \(error.localizedDescription)")
            throw error
        }
    }
    
    private static func createNewPost(withImageUrls urls: [URL], post: Post) async throws -> Post {
        let postToSave = Post(id: post.id, ownerId: post.ownerId, name: post.name, content: post.content, timeStamp: post.timeStamp, imageUrls: urls.map{$0.absoluteString})
        
        // Save the post object to Firestore
        let postsCollection = Firestore.firestore().collection("posts") // Reference to 'posts' collection

        do {
            // Add the document with a specific document ID (post.id)
            let _ = try await postsCollection.document(post.id).setData(postToSave.representation)
            print("post added succcessfully")
            return postToSave

        } catch {
            print("Error creating new post: \(error.localizedDescription)")
            throw error
        }
    }
    
    static func addPostToCurrentUser(postId: String) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            throw NewPostError.noUser
        }

        let userDocument = Firestore.firestore().collection("users").document(currentUserID)

        do {
            // Update the 'posts' field in the user document to add the new post's ID
            try await userDocument.updateData([
                "posts": FieldValue.arrayUnion([postId])
            ])
            print("Added post to user: \(postId)")
        } catch {
            print("Error adding post ID to current user: \(error.localizedDescription)")
            throw error
        }
    }
    
    enum NewPostError: Error {
        case noUser
    }
}
