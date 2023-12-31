//
//  NotificationsViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let notificationsRef = db.collection("notifications")
            .whereField("receiverID", isEqualTo: currentUserId)
        
        listener = notificationsRef.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching notifications: \(error.localizedDescription)")
                self.notifications = []
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No notifications found")
                self.notifications = []
                return
            }

            self.notifications = documents.compactMap { document -> Notification? in
                let data = document.data()
                let senderID = data["senderID"] as? String ?? ""
                let notificationTypeString = data["notificationType"] as? String ?? ""
                let notificationtype = NotificationType(rawValue: notificationTypeString)
                let username = data["username"] as? String ?? ""
                // Parse other notification fields
                
                return Notification(id: document.documentID, username: username ,senderID: senderID, notificationType: notificationtype ?? .comment)
            }
        }
    }
    
    func acceptFriendRequest(_ friendId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let currentUserRef = db.collection("users").document(currentUserId)
        let friendUserRef = db.collection("users").document(friendId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let currentUserDoc = try transaction.getDocument(currentUserRef)
                let friendUserDoc = try transaction.getDocument(friendUserRef)

                guard var currentUserData = currentUserDoc.data(), var friendUserData = friendUserDoc.data() else {
                    print("Document data not found")
                    return nil
                }

                var currentUserFriendsList = currentUserData["friendsList"] as? [String] ?? []
                var friendUserFriendsList = friendUserData["friendsList"] as? [String] ?? []

                if !currentUserFriendsList.contains(friendId) {
                    currentUserFriendsList.append(friendId)
                    currentUserData["friendsList"] = currentUserFriendsList
                    transaction.updateData(currentUserData, forDocument: currentUserRef)
                }

                if !friendUserFriendsList.contains(currentUserId) {
                    friendUserFriendsList.append(currentUserId)
                    friendUserData["friendsList"] = friendUserFriendsList
                    transaction.updateData(friendUserData, forDocument: friendUserRef)
                }
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Transaction successful - friendsList updated for both users")
                completion(true)
            }
        }
    }


    func denyFriendRequest(_ notification: Notification) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Handle the notification as a friend request
        if notification.notificationType == .friendRequest {
            // Logic to deny the friend request
            
            // Remove the notification after denying the friend request
            deleteNotification(notification)
        }
    }
    
    private func deleteNotification(_ notification: Notification) {
        db.collection("notifications").document(notification.id).delete { error in
            if let error = error {
                print("Error deleting notification: \(error.localizedDescription)")
            } else {
                print("Notification deleted successfully")
            }
        }
    }
}

