//
//  ChatViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//

import SwiftUI
import MessageKit
import InputBarAccessoryView
import Firebase

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    var chat: Chat
    @Published var inputText: String = ""

    init(chat: Chat) {
        self.chat = chat
        listenToMessages()
    }
    
    private func listenToMessages() {
        guard let id = chat.id else { return } // Replace channel with chat
        let db = Firestore.firestore()
        let chatReference = db.collection("chats/\(id)/thread") // Update the reference path
        
        chatReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for chat updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    func sendMessage() {
        let user = FVUser(id: Auth.auth().currentUser?.uid ?? "", name: CurrentUser.shared.username ?? "", email: Auth.auth().currentUser?.email ?? "", profilePictureURL: nil, bio: nil, friendsList: [])
        let message = Message(user: user, content: inputText)
        saveMessage(message)
        inputText = "" // Clear inputText after sending the message
    }
    
    private func saveMessage(_ message: Message) {
        guard let id = chat.id else {
            print("Chat ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        let chatReference = db.collection("chats/\(id)/thread") // Update the reference path
        
        chatReference.addDocument(data: message.representation) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                // Message successfully saved in Firestore
                // No need to call handleDocumentChange here
                // Instead, append the message directly to your local array
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            print("Error creating message from document")
            return
        }
        
        switch change.type {
        case .added:
            appendMessage(message)
        case .modified:
            updateMessage(message)
        case .removed:
            removeMessage(message)
        }
    }

    private func appendMessage(_ message: Message) {
        DispatchQueue.main.async { [weak self] in
            if var messages = self?.messages {
                if !messages.contains(message) {
                    messages.append(message)
                    self?.messages = messages
                }
            }
        }
    }

    private func updateMessage(_ message: Message) {
        DispatchQueue.main.async { [weak self] in
            guard let index = self?.messages.firstIndex(where: { $0.id == message.id }) else {
                return
            }
            self?.messages[index] = message
        }
    }

    private func removeMessage(_ message: Message) {
        DispatchQueue.main.async { [weak self] in
            self?.messages.removeAll(where: { $0.id == message.id })
        }
    }

}
