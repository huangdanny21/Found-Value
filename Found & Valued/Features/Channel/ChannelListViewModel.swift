//
//  ChannelListViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ChannelListViewModel: ObservableObject {
    @Published var channels: [Channel] = []
    private var channelsCollection: CollectionReference {
        Firestore.firestore().collection("channels")
    }
    
    func fetchChannels() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let db = Firestore.firestore()
        let channelsCollection = db.collection("channels")

        channelsCollection.getDocuments { (snapshot, error) in
            // Error handling and channel fetching code
            guard let documents = snapshot?.documents else {
                print("No channels found")
                return
            }

            var channels: [Channel] = []
            for document in documents {
                let channelID = document.documentID
                if let channel = Channel(document: document) {
                    channel.id = channelID
                    channels.append(channel)
                }

                let messagesCollection = channelsCollection.document(channelID).collection("thread")
                messagesCollection.getDocuments { (messagesSnapshot, messagesError) in
                    // Fetch messages for each channel if needed
                }
            }
            DispatchQueue.main.async {
                self.channels = channels
            }
        }
    }

    func addChannelToFirestore(channelName: String, messageData: [String: Any], completion: @escaping (Bool, String?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            completion(false, "User is not authenticated")
            return
        }

        let db = Firestore.firestore()
        let channelsCollection = db.collection("channels")

        // Check if a channel with the same name exists
        channelsCollection.whereField("name", isEqualTo: channelName).getDocuments { (snapshot, error) in
            // Handle channel existence checking and creating a new channel as needed
            if let documents = snapshot?.documents, !documents.isEmpty {
                // Channel already exists
                completion(false, "Channel with the name '\(channelName)' already exists.")
                return // Exit the function as the channel already exists
            }

            // Create a new channel as it doesn't exist
            let newChannelRef = channelsCollection.addDocument(data: ["name": channelName]) // Create a new channel

            newChannelRef.collection("thread").addDocument(data: messageData) { error in
                // Handle adding messages to the channel
                if let error = error {
                    completion(false, "Failed to add message: \(error.localizedDescription)")
                } else {
                    let channelID = newChannelRef.documentID
                    completion(true, channelID)
                }
            }
        }
    }
}
