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
    private var db = Firestore.firestore()
    private var userListener: ListenerRegistration?

    init(with username: String) {
        fetchUserProfile()
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
                // Add other user profile details here
            }
        } else if let currentUserID = Auth.auth().currentUser?.uid {
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

    func updateUserProfile(newUsername: String, newEmail: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let userRef = db.collection("users").document(currentUserID)

        userRef.updateData([
            "username": newUsername,
            "email": newEmail
            // Update other user profile details here
        ]) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully")
                // You might want to update the local properties after successful update
                self.username = newUsername
                self.email = newEmail
            }
        }
    }
}

