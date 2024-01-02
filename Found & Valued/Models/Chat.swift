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
    var threads: [Thread]

    init(id: String? = nil, users: [String], threads: [Thread]) {
        self.id = id
        self.users = users
        self.threads = threads
    }

    init(from doc: DocumentSnapshot) {
        self.id = doc.documentID
        self.users = doc.data()?["users"] as? [String] ?? []
        self.threads = []
        if let threadsData = doc.data()?["threads"] as? [[String: Any]] {
            self.threads = threadsData.compactMap { threadData in
                Thread(from: threadData)
            }
        }
    }
}

struct Thread: Identifiable, Codable {
    var id: String?
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
