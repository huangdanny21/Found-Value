//
//  ChannelsViewController.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

final class ChannelsViewController: UITableViewController {
    private let toolbarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let channelCellIdentifier = "channelCell"
    private var hostingController: UIHostingController<FriendListView>?
    private let database = Firestore.firestore()
    private var channelReference: CollectionReference {
        return database.collection("channels")
    }
    
    private var channels: [Channel] = []
    private var channelListener: ListenerRegistration?
    
    private let currentUser: FVUser
    
    deinit {
        channelListener?.remove()
    }
    
    init(currentUser: FVUser) {
        self.currentUser = currentUser
        super.init(style: .grouped)
        
        title = "Channels"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: channelCellIdentifier)
        
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: toolbarLabel),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        ]
        toolbarLabel.text = CurrentUser.shared.username ?? ""
        
        fetchChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    @objc private func addButtonPressed() {
        var friendListView = FriendListView()
        friendListView.userSelected = { user in
            self.dismissFriendListView {
                self.addChannelToFirestore(channelName: user.name, messageData: Channel(name: user.name).representation)
            } // Dismiss FriendListView upon selection
        }

        hostingController = UIHostingController(rootView: friendListView)
        self.present(hostingController!, animated: true, completion: nil)
    }

    private func dismissFriendListView(completion: @escaping (() -> Void)) {
        hostingController?.dismiss(animated: true, completion: completion)
        hostingController = nil // Release reference to hosting controller
    }
    
    // MARK: - Helpers
    
    func fetchChannels() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let db = Firestore.firestore()
        let channelsCollection = db.collection("channels")

        channelsCollection.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching channels: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No channels found")
                return
            }

            for document in documents {
                let channelID = document.documentID

                DispatchQueue.main.async {
                    if let channel = Channel(document: document) {
                        self.addChannelToTable(channel)
                    }
                }

                let messagesCollection = channelsCollection.document(channelID).collection("thread")
                messagesCollection.getDocuments { (messagesSnapshot, messagesError) in
                    if let messagesError = messagesError {
                        print("Error fetching messages for channel \(channelID): \(messagesError.localizedDescription)")
                        return
                    }

                    guard let messagesDocuments = messagesSnapshot?.documents else {
                        print("No messages found for channel \(channelID)")
                        return
                    }

                    // Process fetched messages for the channel and initialize Message objects
                    let messages: [Message] = messagesDocuments.compactMap { messageDocument in
                        guard let message = Message(document: messageDocument) else {
                            print("Error creating Message object from document")
                            return nil
                        }
                        return message
                    }

                    // Use the 'messages' array containing fetched messages as needed
                    print("Fetched messages for channel \(channelID): \(messages)")
                }
            }
        }
    }


    func addChannelToFirestore(channelName: String, messageData: [String: Any]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let db = Firestore.firestore()
        let channelsCollection = db.collection("channels")

        // Check if a channel with the same name exists
        channelsCollection.whereField("name", isEqualTo: channelName)
                         .getDocuments { (snapshot, error) in
            if let error = error {
                print("Error checking channel existence: \(error.localizedDescription)")
                return
            }

            if let documents = snapshot?.documents, !documents.isEmpty {
                // Channel already exists
                print("Channel with the name '\(channelName)' already exists.")
                // Handle existing channel, you might want to retrieve its details or perform specific actions
                // For example: Load existing channel or display an alert

                return // Exit the function as the channel already exists
            }

            // Create a new channel as it doesn't exist
            let newChannelRef = channelsCollection.addDocument(data: ["name": channelName]) // Create a new channel

            newChannelRef.collection("thread").addDocument(data: messageData) { error in
                if let error = error {
                    print("Failed to add message: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        let channel = Channel(name: channelName)
                        let viewController = ChatViewController(user: self.currentUser, channel: channel)
                        self.navigationController?.pushViewController(viewController, animated: true)
                        print("Message added successfully to the channel!")
                    }
                }
            }
        }
    }

    
    private func addChannelToTable(_ channel: Channel) {
        if channels.contains(channel) {
            return
        }
        
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels[index] = channel
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else {
            return
        }
        
        channels.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            addChannelToTable(channel)
        case .modified:
            updateChannelInTable(channel)
        case .removed:
            removeChannelFromTable(channel)
        }
    }
}

// MARK: - TableViewDelegate
extension ChannelsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: channelCellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = channels[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let viewController = ChatViewController(user: currentUser, channel: channel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
