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
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var userItems: [Item] = []
    
    private var user: User?
    
    private var db = Firestore.firestore()
    private var userListener: ListenerRegistration?

    // MARK: Life Cycle
    
    init(with user: User) {
        self.user = user
    }
    
    init(with username: String) {
        self.username = username
        fetchUserProfile(for: username)
    }

    deinit {
        userListener?.remove()
    }
    
    // MARK: - Functions

    func fetchUserProfile(for username: String? = nil) {
        if let requestedUsername = username {
            let userQuery = db.collection("users").whereField("username", isEqualTo: requestedUsername)
            userListener = userQuery.addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching user profile: \(error.localizedDescription)")
                    return
                }

                guard let document = querySnapshot?.documents.first else {
                    print("User not found")
                    return
                }

                let data = document.data()
                self.username = data["username"] as? String ?? ""
                self.email = data["email"] as? String ?? ""

                // Fetch items associated with the user
                let itemsQuery = self.db.collection("items").whereField("userID", isEqualTo: document.documentID)
                itemsQuery.getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching user items: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        print("No items found")
                        return
                    }

                    // Populate userItems with the fetched items
                    self.userItems = documents.compactMap { document in
                        let data = document.data()
                        // Create Item objects based on fetched data and return
                        // Example:
                        let id = data["id"] as? String ?? ""
                        let itemName = data["itemName"] as? String ?? ""
                        let imageUrl = data["imageUrl"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        return Item(id: UUID(uuidString: id) ?? UUID(), name: itemName,description: description, imageURL: URL(string: imageUrl))
                    }
                }
            }
        } else {
            // Fetch user profile details for the authenticated user
            if let currentUserID = Auth.auth().currentUser?.uid {
                let currentUserDocRef = db.collection("users").document(currentUserID)
                userListener = currentUserDocRef.addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error fetching user profile: \(error.localizedDescription)")
                        return
                    }

                    guard let document = documentSnapshot, document.exists else {
                        print("User not found")
                        return
                    }

                    let data = document.data()
                    self.username = data?["username"] as? String ?? ""
                    self.email = data?["email"] as? String ?? ""
                    // Add other user profile details here
                }
            } else {
                print("User not authenticated")
            }
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
        
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("friendRequests").addDocument(data: [
            "senderID": currentUserId,
            "receiverID": user?.id.uuidString ?? "",
            "status": "pending" // You can set different statuses for friend requests
        ]) { error in
            if let error = error {
                print("Error sending friend request: \(error.localizedDescription)")
            } else {
                print("Friend request sent successfully")
            }
        }
    }
}
