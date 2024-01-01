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
    var channel: Channel
    @Published var inputText: String = ""

    init(channel: Channel) {
        self.channel = channel
        listenToMessages()
    }
    
    private func listenToMessages() {
        guard let id = channel.id else { return }
        let db = Firestore.firestore()
        let channelReference = db.collection("channels/\(id)/thread")
        
        channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
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
    
    private func takePhoto() {
        // Implement logic to handle taking a photo
    }
    
    private func saveMessage(_ message: Message) {
        guard let id = channel.id else {
            print("Channel ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        let channelReference = db.collection("channels/\(id)/thread")
        
        channelReference.addDocument(data: message.representation) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        // Handle document change logic here
    }
}
