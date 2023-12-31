//
//  Notification.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation

enum NotificationType: String {
    case friendRequest
    case comment
}

struct Notification: Identifiable {
    var id: String
    var username: String
    let senderID: String
    let notificationType: NotificationType
    // Other notification properties
}
