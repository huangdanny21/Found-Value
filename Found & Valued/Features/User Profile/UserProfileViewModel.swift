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
            return
        }
        
        // Assuming 'user' is the user being viewed or the receiver of the friend request
        guard let receiverId = user?.id else {
            print("Receiver ID not found")
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
                return
            }
            
            guard let documents = snapshot?.documents else {
                // If no pending request found, proceed to send a new request
                db.collection("friendRequests").addDocument(data: [
                    "senderID": currentUserId,
                    "receiverID": receiverId,
                    "status": "pending" // Set status to pending for a new request
                ]) { error in
                    if let error = error {
                        print("Error sending friend request: \(error.localizedDescription)")
                    } else {
                        print("Friend request sent successfully")
                    }
                }
                return
            }
            
            // Handle the case where there is an existing pending request
            if let existingRequest = documents.first {
                let existingRequestId = existingRequest.documentID
                print("There's already a pending request")
                // You can handle this case as needed, such as showing an alert to the user
                // or providing a way to cancel the existing request
                
                // Example: Cancel the existing request by deleting the document
                db.collection("friendRequests").document(existingRequestId).delete { error in
                    if let error = error {
                        print("Error canceling existing request: \(error.localizedDescription)")
                        completion(false) // Send false in case of failure
                    } else {
                        print("Existing request canceled successfully")
                        // After canceling the request, send a new one
                        db.collection("friendRequests").addDocument(data: [
                            "senderID": currentUserId,
                            "receiverID": receiverId,
                            "status": "pending" // Set status to pending for a new request
                        ]) { error in
                            if let error = error {
                                print("Error sending friend request: \(error.localizedDescription)")
                                completion(false) // Send false in case of failure
                            } else {
                                print("Friend request sent successfully")
                                completion(true) // Send false in case of failure
                            }
                        }
                    }
                }
            }
        }
    }

}
