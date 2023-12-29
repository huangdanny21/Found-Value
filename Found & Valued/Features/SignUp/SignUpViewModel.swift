//
//  SignUpViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var signUpError: String?
    @Published var didSignUpSuccessfully = false

    // MARK: Functions
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.signUpError = error.localizedDescription
            } else {
                // Handle successful sign-up, e.g., navigate to another screen
                print("User signed up successfully!")
                self.didSignUpSuccessfully = true
            }
        }
    }

    // Assuming this function is called after a successful signup
    func addUserToFirestore(username: String, email: String) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? "" // Get the current user's ID

        // Create a reference to the "users" collection in Firestore
        let usersRef = db.collection("users")

        // Define the user data
        let userData: [String: Any] = [
            "username": username,
            "email": email
            // Add other user data as needed
        ]

        // Add the user data to Firestore
        usersRef.document(userID).setData(userData) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
            } else {
                print("User added to Firestore successfully")
            }
        }
    }

}
