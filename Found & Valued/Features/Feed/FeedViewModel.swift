//
//  FeedViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import FirebaseAuth

class FeedViewModel: ObservableObject {
    @Published var items: [Item] = []

    func fetchPublicFeeds() {
        let db = Firestore.firestore()
        let postsCollection = db.collection("publicFeed").document("posts").collection("posts")
        
        postsCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching public feed items: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No public feed items found")
                return
            }

            self.items = documents.compactMap { document in
                let data = document.data()
                // Create an Item object from the retrieved data
                // Example:
                let itemTitle = data["title"] as? String ?? ""
                let itemDescription = data["description"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                return Item(id: document.documentID, name: itemTitle, description: itemDescription, imageURL: URL(string: imageURL))
            }
        }
    }
}
