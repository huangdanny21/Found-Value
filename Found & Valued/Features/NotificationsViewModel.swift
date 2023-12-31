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
    @Published var notifications: [FriendRequestNotification] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func fetchNotifications() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let notificationsRef = db.collection("notifications").whereField("receiverID", isEqualTo: currentUserID)
        
        listener = notificationsRef.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching notifications: \(error.localizedDescription)")
                self.notifications = []
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No notification documents")
                self.notifications = []
                return
            }
            
            self.notifications = documents.compactMap { document -> FriendRequestNotification? in
                let data = document.data()
                guard
                    let notificationID = data["notificationID"] as? String,
                    let senderID = data["senderID"] as? String,
                    let requestStatusString = data["requestStatus"] as? Int,
                    let requestStatus = RequestStatus(rawValue: requestStatusString)
                    else { return nil }
                
                return FriendRequestNotification(
                    notificationID: notificationID,
                    senderID: senderID,
                    requestStatus: requestStatus
                    // Initialize other properties based on your model
                )
            }
        }
    }
}

