//
//  CurrentUser.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CurrentUser {
    static let shared = CurrentUser()
    
    var userID: String?
    var username: String?
    var email: String?
    var profilePictureURL: URL?
    
    private let db = Firestore.firestore()
    
    private init() {
        setupCurrentUser()
    }
    
    func setupCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            fetchUserData(userID: currentUser.uid)
        }
    }
    
    private func fetchUserData(userID: String) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.username = userData?["username"] as? String
                self.email = userData?["email"] as? String
                if let profilePictureURLString = userData?["profilePictureURL"] as? String {
                    self.profilePictureURL = URL(string: profilePictureURLString)
                }
                // Add other user data as needed
            } else {
                print("Document does not exist")
            }
        }
    }
}
