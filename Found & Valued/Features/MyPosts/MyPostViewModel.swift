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
    private let userID = "your_user_id" // Replace with the actual user ID

    func fetchMyPosts() {
        let postsCollection = db.collection("myPosts").document("posts").collection(userID)
        
        listener = postsCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching my posts: \(error.localizedDescription)")
                self.posts = []
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No posts found")
                self.posts = []
                return
            }

            self.posts = documents.compactMap { document in
                let data = document.data()
                // Create a Post object from the retrieved data
                let userid = data["UserID"] as? String ?? ""
                let title = data["itemTitle"] as? String ?? ""
                let itemDescription = data["itemDescription"] as? String ?? ""
                let imageUrlString = data["imageURL"] as? String ?? ""
                let item = Item(id: document.documentID, name: title, description: itemDescription, imageURL: URL(string: imageUrlString))
                return Post(id: userid, item: item)
            }
        }
    }
}
