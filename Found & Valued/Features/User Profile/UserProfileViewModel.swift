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
    var areUsersFriends = false
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

    func checkIfUsersAreFriends() {
        guard let currentUserID = Auth.auth().currentUser?.uid,
              let viewedUserID = user?.id else {
            print("User not authenticated or viewed user ID is nil")
            return
        }

        let db = Firestore.firestore()

        // Check if the viewed user is in the friend list of the current user
        db.collection("users").document(currentUserID).collection("friends").document(viewedUserID).getDocument { snapshot, error in
            if let error = error {
                print("Error checking friendship: \(error.localizedDescription)")
                return
            }

            if let _ = snapshot?.data() {
                // Users are friends
                self.areUsersFriends = true
            } else {
                // Users are not friends
                self.areUsersFriends = false
            }
        }
    }

    func updateUserProfile(newUsername: String, newEmail: String) {
        // Implementation for updating user profile
        // Similar to your existing updateUserProfile method
    }
    
    func sendFriendRequest(completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            completion(false)
            return
        }
        
        // Assuming 'user' is the user being viewed or the receiver of the friend request
        guard let receiverId = user?.id else {
            print("Receiver ID not found")
            completion(false)
            return
        }

        let db = Firestore.firestore()
        
        // Check if there's already a pending request from the sender to the receiver
        let requestQuery = db.collection("friendRequests")
            .whereField("senderID", isEqualTo: currentUserId)
            .whereField("receiverID", isEqualTo: receiverId)
            .whereField("status", isEqualTo: "pending")
        
        requestQuery.getDocuments { snapshot, error in
            if let error = error {
                print("Error checking existing request: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard snapshot?.isEmpty ?? true else {
                print("There's already a pending request")
                completion(false)
                return
            }
            
            // Send a new friend request
            let newRequestRef = db.collection("friendRequests").addDocument(data: [
                "senderID": currentUserId,
                "receiverID": receiverId,
                "username": CurrentUser.shared.username ?? "Error",
                "status": "pending" // Set status to pending for a new request
            ])
            
            // Get the newly created document ID
            
            db.collection("notifications").addDocument(data: [
                "senderID": currentUserId,
                "receiverID": receiverId,
                "requestID": newRequestRef.documentID, // Include the request ID for reference
                "notificationType": "friendRequest",
                "username": CurrentUser.shared.username ?? "",
                "status": "unread"
                // Add other necessary fields to the notification
            ]) { error in
                if let error = error {
                    print("Error adding notification: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                print("Friend request sent successfully")
                completion(true)
            }
        }
    }
}
