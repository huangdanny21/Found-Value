//
//  FriendListViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

class FriendListViewModel: ObservableObject {
    @Published var friendsList: [FVUser] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchFriendsList() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let currentUserRef = db.collection("users").document(currentUserId)
        
        listener = currentUserRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching friends list: \(error.localizedDescription)")
                self.friendsList = []
                return
            }
            
            guard let data = snapshot?.data(), let friends = data["friendsList"] as? [String] else {
                print("Friends list not found")
                self.friendsList = []
                return
            }
            
            // Fetch User objects for each friend in the friendsList
            var users: [FVUser] = []
            let dispatchGroup = DispatchGroup()
            
            for friendId in friends {
                dispatchGroup.enter()
                let friendRef = self.db.collection("users").document(friendId)
                friendRef.getDocument { friendSnapshot, friendError in
                    defer { dispatchGroup.leave() }
                    if let friendError = friendError {
                        print("Error fetching friend with ID \(friendId): \(friendError.localizedDescription)")
                        return
                    }
                    
                    if let friendData = friendSnapshot?.data() {
                        let friend = FVUser(
                            id: friendId,
                            name: friendData["username"] as? String ?? "",
                            email: friendData["email"] as? String,
                            profilePictureURL: URL(string: friendData["profilePictureURL"] as? String ?? ""),
                            bio: friendData["bio"] as? String ?? "",
                            items: [], // Populate the items if needed
                            friendsList: [] // Populate the friendsList if needed
                            // Add other user attributes as needed
                        )
                        users.append(friend)
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // All friend details are fetched, update the friendsList array with User objects
                self.friendsList = users
            }
        }
    }

}
