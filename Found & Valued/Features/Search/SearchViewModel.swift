//
//  SearchViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import FirebaseFirestore

class SearchViewModel: ObservableObject {
    @Published var searchResults: [String] = [] // Store search results
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func searchUser(withUsername username: String) {
        // Remove any existing listener
        listener?.remove()

        listener = db.collection("users")
            .whereField("username", isEqualTo: username)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    self.searchResults = []
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    self.searchResults = []
                    return
                }
                
                let usernames = documents.compactMap { $0.data()["username"] as? String }
                self.searchResults = usernames
            }
    }
}
