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

        chatIds.forEach { chatId in
            let chatRef = db.collection("chats").document(chatId)
            
            chatRef.getDocument(as: Chat.self) { result in
                switch result {
                case .success(let chat):
                    DispatchQueue.main.async {
                        self.chats.append(chat)
                    }
                case .failure(let error):
                    print("Error fetching chat details for \(chatId): \(error.localizedDescription)")
                }
            }
        }
    }

    func addChatToFirestore(receiverUser: FVUser) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let db = Firestore.firestore()

        // Prepare the document reference paths for the current user and receiver user
        let currentUserRef = db.collection("users").document(currentUserID)
        let receiverUserRef = db.collection("users").document(receiverUser.id)

        // Check if the chat reference exists for the current user
        currentUserRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching current user document: \(error.localizedDescription)")
                return
            }

            // If the current user document exists
            if let document = document, document.exists {
                var chatIDs = document.get("chatIds") as? [String] ?? []
                
                // Check if chat reference already exists for the receiver user
                if chatIDs.contains(where: { $0.contains(receiverUser.id) }) {
                    print("Chat reference already exists for these users.")
                    return
                }

                // Create a new chat reference
                let chatRef = db.collection("chats").document()
                let chatID = chatRef.documentID

                // Update the chatIds for the current user
                chatIDs.append(chatID)
                currentUserRef.setData(["chatIds": chatIDs], merge: true) { currentUserError in
                    if let currentUserError = currentUserError {
                        print("Error updating current user's document: \(currentUserError.localizedDescription)")
                        return
                    }
                    print("Chat ID added to the current user's document")
                }

                // Update the chatIds for the receiver user
                receiverUserRef.getDocument { (receiverDocument, receiverError) in
                    if let receiverError = receiverError {
                        print("Error fetching receiver user document: \(receiverError.localizedDescription)")
                        return
                    }

                    if let receiverDocument = receiverDocument, receiverDocument.exists {
                        var receiverChatIDs = receiverDocument.get("chatIds") as? [String] ?? []
                        receiverChatIDs.append(chatID)

                        receiverUserRef.setData(["chatIds": receiverChatIDs], merge: true) { receiverUserError in
                            if let receiverUserError = receiverUserError {
                                print("Error updating receiver user's document: \(receiverUserError.localizedDescription)")
                                return
                            }
                            print("Chat ID added to the receiver user's document")
                        }
                    }
                }

                // Create the chat data and add it to Firestore
                let chatData = [
                    "id": chatID,
                    "users": [currentUserID, receiverUser.id],
                    "senderName": CurrentUser.shared.username ?? "",
                    "receiverName": receiverUser.name
                ] as [String: Any]

                chatRef.setData(chatData) { error in
                    if let error = error {
                        print("Error adding chat document: \(error.localizedDescription)")
                    } else {
                        print("Chat document added to Firestore")
                    }
                }
            }
        }
    }
}
