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
    
    private var db = Firestore.firestore()
    private var userListener: ListenerRegistration?

    init(with username: String) {
        fetchUserProfile(for: username)
    }

    deinit {
        userListener?.remove()
    }

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
}
