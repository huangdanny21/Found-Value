//
//  SignUpViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
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
}
