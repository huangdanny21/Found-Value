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

        let chatsCollection = db.collection("Chats")

        chatsCollection.whereField("users", arrayContains: currentUserID).getDocuments { [weak self] (snapshot, error) in
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
}
