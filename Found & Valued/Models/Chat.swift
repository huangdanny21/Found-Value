//
//  Chat.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/1/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    var users: [String]
    var receiverName: String?
    var senderName: String?
    var threads: [Thread]?

    init(id: String? = nil, receiverName: String? = nil, senderName: String? = nil, users: [String], threads: [Thread]? = nil) {
        self.id = id
        self.receiverName = receiverName
        self.senderName = senderName
        self.users = users
        self.threads = threads
    }
}

struct Thread: Identifiable, Codable {
    @DocumentID var id: String?
    let content: String
    let created: String
    let senderID: String
    let senderName: String

    init(id: String? = nil, content: String, created: String, senderID: String, senderName: String) {
        self.id = id
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }

    init(from data: [String: Any]) {
        self.id = data["id"] as? String
        self.content = data["content"] as? String ?? ""
        self.created = data["created"] as? String ?? ""
        self.senderID = data["senderID"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
    }
}
