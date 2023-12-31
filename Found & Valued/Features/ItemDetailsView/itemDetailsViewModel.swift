//
//  itemDetailsViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ItemDetailsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    

    // Function to fetch comments for a specific item
    func fetchComments(for itemId: String) {
        let commentsRef = db.collection("items").document(itemId).collection("comments")
        
        listener = commentsRef.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching comments: \(error.localizedDescription)")
                self.comments = []
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No comments found")
                self.comments = []
                return
            }

            self.comments = documents.compactMap { document -> Comment? in
                let data = document.data()
                let text = data["text"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                // Parse other comment fields if needed
                
                return Comment(id: document.documentID, username: username, text: text)
            }
        }
    }

    // Function to add a comment to an item
    func addComment(to itemId: String, text: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let commentsRef = db.collection("items").document(itemId).collection("comments")
        
        commentsRef.addDocument(data: [
            "userID": currentUserId,
            "username": CurrentUser.shared.username ?? "",
            "text": text
            // You can add other fields as needed for the comment
        ]) { error in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
            } else {
                print("Comment added successfully")
            }
        }
    }
}
