//
//  UserProfileViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import FirebaseAuth
import FirebaseFirestore
import Combine

class UserProfileViewModel: ObservableObject {
    @Published var userItems: [Item] = []
    
    var user: User?
    
    private var db = Firestore.firestore()
    private var userListener: ListenerRegistration?

    // MARK: Life Cycle
    
    init(with user: User) {
        self.user = user
    }

    deinit {
        userListener?.remove()
    }
    
    // MARK: - Functions

    func fetchUserItems(for user: User) {
        let itemsRef = db.collection("users").document(user.id).collection("items")
        itemsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user's items: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No items found for the user")
                return
            }
            
            let userItems = documents.compactMap { document -> Item? in
                let data = document.data()
                // Populate Item objects based on fetched data and return
                // Example:
                let id = itemsRef.collectionID
                let itemName = data["itemName"] as? String ?? ""
                let imageUrl = data["imageUrl"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                return Item(id: UUID(uuidString: id) ?? UUID(), name: itemName, description: description, imageURL: URL(string: imageUrl))
            }
            self.userItems = userItems
        }
    }


    func updateUserProfile(newUsername: String, newEmail: String) {
        // Implementation for updating user profile
        // Similar to your existing updateUserProfile method
    }
    
    func sendFriendRequest() {
        // Logic to send a friend request to this user
        // This could involve updating the user's friend list or sending a request to the other user
        
        // For example (pseudo code):
        // You can access the current user's ID using Auth.auth().currentUser?.uid
        // Then update a field in the user's document in Firestore indicating the friend request
        
        
//        guard let currentUserId = Auth.auth().currentUser?.uid else {
//            print("User not authenticated")
//            return
//        }
//
//        let db = Firestore.firestore()
//        db.collection("friendRequests").addDocument(data: [
//            "senderID": currentUserId,
//            "receiverID": user?.id.uuidString ?? "",
//            "status": "pending" // You can set different statuses for friend requests
//        ]) { error in
//            if let error = error {
//                print("Error sending friend request: \(error.localizedDescription)")
//            } else {
//                print("Friend request sent successfully")
//            }
//        }
    }
}
