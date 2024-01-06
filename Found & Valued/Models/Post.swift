//
//  Post.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation

struct Post: Identifiable, Codable, Sendable, Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let ownerId: String
    let name: String
    let content: String
    let timeStamp: String?
    let imageUrls: [String]
    var likes: [SimpleUser]?
    var comments: [Comment]?
}

extension Post: DatabaseRepresentation {
    var representation: [String: Any] {
        var rep: [String: Any] = [
            "id": id,
            "ownerId": ownerId,
            "name": name,
            "content": content,
            "imageUrls": imageUrls
        ]
        
        if let timeStamp = timeStamp {
            rep["timeStamp"] = timeStamp
        }
        if let comments = comments {
            rep["comments"] = comments
        }
        
        return rep
    }
}
