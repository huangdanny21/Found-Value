//
//  RandomUserGenerator.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation
import Firebase

class RandomUserGenerator {
    func createRandomUsers() {
        let db = Firestore.firestore()
        
        let randomUsername = generateRandomUsername()
        let randomEmail = generateRandomEmail()
        let randomPassword = generateRandomPassword()
        
        // Create a new user in Firebase Authentication
        Auth.auth().createUser(withEmail: randomEmail, password: randomPassword) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Error creating user: \(error!.localizedDescription)")
                return
            }
            
            let userData: [String: Any] = [
                "username": randomUsername,
                "email": randomEmail,
                "id": user.uid
                // Add other user details as needed
            ]
            
            // Add the user details to Firestore
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    print("Error adding user data to Firestore: \(error.localizedDescription)")
                } else {
                    print("User added successfully to Firestore")
                }
            }
        }
    }

    func generateRandomUsername() -> String {
        let adjectives = ["Test ,Happy", "Silly", "Clever", "Brave", "Gentle", "Lively", "Fancy", "Cheerful", "Calm", "Eager"]
        let nouns = ["Cat", "Dog", "Lion", "Tiger", "Elephant", "Bear", "Rabbit", "Fox", "Wolf", "Penguin"]
        let uuid =  String(UUID().uuidString.prefix(5))
        let randomAdjective = adjectives.randomElement() ?? ""
        let randomNoun = nouns.randomElement() ?? ""
        
        return randomAdjective + randomNoun + uuid
    }

    func generateRandomEmail() -> String {
        let domains = ["gmail.com", "yahoo.com", "hotmail.com", "outlook.com", "icloud.com"]
        let randomDomain = domains.randomElement() ?? ""
        
        let username = generateRandomUsername()
        
        return "\(username)@\(randomDomain)"
    }

    func generateRandomPassword() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let passwordLength = 10
        
        let randomPassword = String((0..<passwordLength).map { _ in letters.randomElement()! })
        return randomPassword
    }

}
