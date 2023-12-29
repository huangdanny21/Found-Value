//
//  LoginView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
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
}
