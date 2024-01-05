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
import FirebaseFirestoreSwift

struct NewPostService {
    
    func createPost(with images: [UIImage], post: Post) async throws {
        do {
            let urls = try await storeImages(images: images)
            await self.createNewPost(withImageUrls: urls, post: post)
        } catch {
            print("Cannot create post: \(error.localizedDescription)")
        }
    }
    
    func storeImages(images: [UIImage]) async throws -> [String] {
        do {
            let urls = try await ImageStorageService.uploadAsJPEG(images: images, path: "postImages")
            return urls.map{ $0.absoluteString }
        } catch {
            print("Error uploading image: \(error.localizedDescription)")
            return []
        }
    }
    
    private func createNewPost(withImageUrls urls: [String], post: Post) async {
        let postToSave = Post(id: post.id, ownerId: post.ownerId, name: post.name, content: post.content, timeStamp: post.timeStamp, imageUrls: urls).representation
        
        // Save the post object to Firestore
        let postsCollection = Firestore.firestore().collection("posts") // Reference to 'posts' collection

        do {
            // Add the document with a specific document ID (post.id)
            let _ = try await postsCollection.document(post.id).setData(postToSave)
            print("post added succcessfully")

        } catch {
            print("Error creating new post: \(error.localizedDescription)")
        }
    }

}
