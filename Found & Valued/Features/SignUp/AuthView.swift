//
//  AuthView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            NavigationView {
                HomeViewControllerWrapper()
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            }
            .onAppear {
                checkAuthentication()
            }
        } else {
            NavigationView {
                LoginView(onLogin: {
                    isLoggedIn = true // Set isLoggedIn to true after successful login
                }, onSignUp: {
                    isLoggedIn = true // Set isLoggedIn to true after successful signup
                })
            }
        }
    }
    
    func checkAuthentication() {
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                // User is logged in anonymously
                isLoggedIn = true
            } else {
                // User is logged in with an authenticated account
                isLoggedIn = true
                // You can handle other authenticated users here
            }
        } else {
            // User is not logged in
            isLoggedIn = false
        }
    }
}
