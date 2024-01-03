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

        let currentUserChatsRef = db.collection("users").document(currentUserID)
        currentUserChatsRef.addSnapshotListener { snapshot, error in

            if let error = error {
                print("Error fetching chats: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data(), let chatIds = data["chatIds"] as? [String] else {
                print("chatsId list not found")
                return
            }

            self.fetchChats(for: chatIds)
        }
    }
    
    func fetchChats(for chatIds: [String]) {
        var chats: [Chat] = []

        for chatId in chatIds {
            let chatRef = db.collection("chats").document(chatId)

            chatRef.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching chat details for \(chatId): \(error.localizedDescription)")
                    return
                }

                if let document = document, document.exists {
                    // Extract chat details from the document
                    let chat = Chat(from: document)
                    chats.append(chat)

                    // Check if this is the last chat to add to the array
                    if chats.count == chatIds.count {
                        // All chat details are fetched, update the view model's chats array
                        DispatchQueue.main.async {
                            self.chats = chats
                        }
                    }
                }
            }
        }
    }

    func addChatToFirestore(receiverUser: FVUser) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let chatRef = db.collection("chats").document() // Auto-generated document ID
        let chatID = chatRef.documentID

        let currentUserRef = db.collection("users").document(currentUserID)
        currentUserRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching current user document: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                var chatIDs = document.get("chatIds") as? [String] ?? []
                chatIDs.append(chatID)

                currentUserRef.setData(["chatIds": chatIDs], merge: true) { currentUserError in
                    if let currentUserError = currentUserError {
                        print("Error updating current user's document: \(currentUserError.localizedDescription)")
                    } else {
                        let chat = Chat(id: chatRef.documentID, users: [currentUserID, receiverUser.id], threads: [])
                        DispatchQueue.main.async {
                            self.chats.append(chat)
                        }
                        print("Chat ID added to the current user's document")
                    }
                }
            }
        }

        let receiverUserRef = db.collection("users").document(receiverUser.id)
        receiverUserRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching receiver user document: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                var chatIDs = document.get("chatIds") as? [String] ?? []
                chatIDs.append(chatID)

                receiverUserRef.setData(["chatIds": chatIDs], merge: true) { receiverUserError in
                    if let receiverUserError = receiverUserError {
                        print("Error updating receiver user's document: \(receiverUserError.localizedDescription)")
                    } else {
                        print("Chat ID added to the receiver user's document")
                    }
                }
            }
        }

        let chatData = ["id": chatID, "users": [currentUserID, receiverUser.id]] as [String: Any]
        chatRef.setData(chatData) { error in
            if let error = error {
                print("Error adding chat document: \(error.localizedDescription)")
            } else {
                print("Chat document added to Firestore")
            }
        }
    }

}
