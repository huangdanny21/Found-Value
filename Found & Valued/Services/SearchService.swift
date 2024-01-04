//
//  SearchService.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import Foundation
import FirebaseFirestore

struct SearchService {
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func searchUser(withUsername username: String) async throws -> [FVUser] {
        do {
            let querySnapshot = try await db.collection("users")
                .whereField("username", isEqualTo: username)
                .getDocuments()
            
            let documents = querySnapshot.documents
            
            let users = documents.compactMap { document -> FVUser? in
                let data = document.data()
                guard let name = data["username"] as? String else { return nil }
                let email = data["email"] as? String
                let profilePictureURLString = data["profilePictureURL"] as? String
                let profilePictureURL = URL(string: profilePictureURLString ?? "")
                let bio = data["bio"] as? String
                let id = data["id"] as? String ?? ""
                return FVUser(id: id, name: name, email: email, profilePictureURL: profilePictureURL, bio: bio, friendsList: [])
            }
            
            return users
        } catch {
            throw error
        }
    }


}
