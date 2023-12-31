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
    
    func acceptFriendRequest(_ notification: Notification) {
           guard let currentUserId = Auth.auth().currentUser?.uid else {
               print("User not authenticated")
               return
           }
           
           // Handle the notification as a friend request
        if notification.notificationType == .friendRequest {
               // Logic to accept the friend request and update the database
               
               // For example:
               // You might want to update the user's friend list in the database
               let currentUserRef = db.collection("users").document(currentUserId)
               currentUserRef.getDocument { snapshot, error in
                   if let error = error {
                       print("Error fetching current user data: \(error.localizedDescription)")
                       return
                   }
                   
                   guard var currentUser = snapshot?.data() as? [String: Any] else {
                       print("Current user data not found")
                       return
                   }
                   
                   // Check if the user has a friendsList
                   if var friendsList = currentUser["friendsList"] as? [String] {
                       // Friends list exists, add the sender ID as a friend
                       friendsList.append(notification.senderID)
                       currentUser["friendsList"] = friendsList
                   } else {
                       // Friends list doesn't exist, create a new one with the sender ID
                       currentUser["friendsList"] = [notification.senderID]
                   }
                   
                   currentUserRef.setData(currentUser) { error in
                       if let error = error {
                           print("Error updating current user data: \(error.localizedDescription)")
                       } else {
                           print("Friend added to friends list")
                           
                           // Remove the notification after accepting the friend request
                           self.deleteNotification(notification)
                       }
                   }
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

