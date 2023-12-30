//
//  LoginView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    
    var onLogin: () -> Void
    var onSignUp: () -> Void

    var body: some View {
        VStack {
            Text("Trade")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    // Handle login action
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                
                Button("Sign Up") {
                    signUp()
                }
                .padding(.top, 8)
            }
            .padding()
            .frame(maxWidth: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                // Handle error, display an alert, etc.
            } else {
                print("User created successfully")
                // User signed up successfully, handle the transition to the next view or action
                addUserToFirestore(username: self.username, email: email)
                onLogin()
                // For example, you might navigate to the HomeView after successful signup
                // Navigate to HomeView or perform any other action
            }
        }
    }
    
    func login() {
         Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
             if let error = error {
                 print("Error signing in: \(error.localizedDescription)")
                 // Handle error, display an alert, etc.
             } else {
                 print("User logged in successfully")
                 // User logged in successfully, handle the transition to the next view or action
                 onLogin()
                 // For example, you might navigate to the HomeView after successful login
                 // Navigate to HomeView or perform any other action
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
            "email": email,
            "id": userID
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
