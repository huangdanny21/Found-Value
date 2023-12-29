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
    @Published var feedItems: [FeedItem] = []

    func fetchPublicFeeds() {
        let db = Firestore.firestore()
        db.collection("PublicFeed").document("Posts").collection("Posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching public feed items: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No public feed items found")
                return
            }

            self.feedItems = documents.compactMap { document in
                let data = document.data()
                // Create a FeedItem object from the retrieved data
                // Example:
                let itemTitle = data["itemTitle"] as? String ?? ""
                let itemDescription = data["itemDescription"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                return FeedItem(id: document.documentID, itemTitle: itemTitle, itemDescription: itemDescription, imageURL: imageURL)
            }
        }
    }
}
