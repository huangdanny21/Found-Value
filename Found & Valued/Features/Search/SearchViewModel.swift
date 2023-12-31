//
//  SearchViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import FirebaseFirestore

class SearchViewModel: ObservableObject {
    @Published var users: [FVUser] = []
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func searchUser(withUsername username: String) {
        listener?.remove()

        listener = db.collection("users")
            .whereField("username", isEqualTo: username)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    self.users = []
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    self.users = []
                    return
                }
                
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
                
                self.users = users
            }
    }
}
