//
//  MyPostViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class MyPostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let userID = CurrentUser.shared.userID ?? "" // Replace with the actual user ID

    func fetchMyPosts() {
        let postsCollection = db.collection("MyPosts").document(userID)

        listener = postsCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching my posts: \(error.localizedDescription)")
                self.posts = []
                return
            }
            
            guard let document = snapshot, document.exists, let postIDs = document.get("postids") as? [String] else {
                print("No posts found")
                self.posts = []
                return
            }

            var fetchedPosts: [Post] = []
            let dispatchGroup = DispatchGroup()

            for postID in postIDs {
                dispatchGroup.enter()

                self.db.collection("publicFeed").document("posts").collection("posts").document(postID).getDocument { postDocument, error in
                    defer {
                        dispatchGroup.leave()
                    }

                    if let error = error {
                        print("Error fetching post \(postID): \(error.localizedDescription)")
                        return
                    }

                    if let postDocument = postDocument, postDocument.exists, let data  = postDocument.data() {
                        let itemTitle = data["itemTitle"] as? String ?? ""
                        let itemDescription = data["itemDescription"] as? String ?? ""
                        let imageUrlString = data["imageURL"] as? String ?? ""
                        let item = Item(id: postDocument.documentID, name: itemTitle, description: itemDescription, imageURL: URL(string: imageUrlString))
                        let post = Post(id: self.userID, item: item)
                        fetchedPosts.append(post)
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.posts = fetchedPosts
            }
        }
    }

}
