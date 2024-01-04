//
//  FeedViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import FirebaseAuth

class FeedViewModel: ObservableObject {
    @Published var items: [Item] = []

    func fetchUserPosts() {
        let db = Firestore.firestore()
        let userPostsCollection = db.collection("publicFeed").document("posts").collection("posts")

        userPostsCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No user posts found")
                return
            }
            
            self.items = documents.compactMap { document in
                let data = document.data()
                let itemTitle = data["itemTitle"] as? String ?? ""
                let itemDescription = data["itemDescription"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                return Item(id: document.documentID, name: itemTitle, description: itemDescription, imageURL: URL(string: imageURL))
            }
        }
    }
}

