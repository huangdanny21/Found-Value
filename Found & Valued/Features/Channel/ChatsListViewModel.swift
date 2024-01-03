//
//  ChatsListViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/1/24.
//

import Foundation
import Firebase

class ChatListViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    private var db = Firestore.firestore()

    func fetchChatsForCurrentUser() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let currentUserChatsRef = db.collection("users").document(currentUserID).collection("chats")

        currentUserChatsRef.getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching chats: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No chats found")
                return
            }

            var chats: [Chat] = []
            for document in documents {
                let chat = Chat(from: document)
                chats.append(chat)
            }

            DispatchQueue.main.async {
                self.chats = chats
            }
        }
    }

    func addChatToFirestore(receiverUser: FVUser) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let chatRef = db.collection("chats").document() // Auto-generated document ID
        let chatData = ["id": chatRef.documentID, "users": [currentUserID, receiverUser.id]] as [String : Any]

        // Add chat reference to the current user's "chats" sub-collection
        let currentUserChatsRef = db.collection("users").document(currentUserID).collection("chats").document(chatRef.documentID)
        currentUserChatsRef.setData(chatData) { error in
            if let error = error {
                print("Error adding chat reference to current user: \(error.localizedDescription)")
            } else {
                let chat = Chat(id: chatRef.documentID, users: [currentUserID, receiverUser.id], threads: [])
                DispatchQueue.main.async {
                    self.chats.append(chat)
                }
                print("Chat reference added to current user's 'chats' sub-collection")
            }
        }

        // Add chat reference to the receiver user's "chats" sub-collection
        let receiverUserChatsRef = db.collection("users").document(receiverUser.id).collection("chats").document(chatRef.documentID)
        receiverUserChatsRef.setData(chatData) { error in
            if let error = error {
                print("Error adding chat reference to receiver user: \(error.localizedDescription)")
            } else {
                print("Chat reference added to receiver user's 'chats' sub-collection")
            }
        }
    }
}
