//
//  FriendRequestNotification.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation

struct FriendRequestNotification {
    let notificationID: String // Unique identifier for the notification
    let senderID: String // ID of the user sending the friend request
    let requestStatus: RequestStatus // Status of the friend request (e.g., pending, accepted, declined)
    // Other properties related to the friend request notification
    
    // You can include other relevant data as needed
}

enum RequestStatus: Int {
    case pending
    case accepted
    case declined
    // Add more status options as required
}
