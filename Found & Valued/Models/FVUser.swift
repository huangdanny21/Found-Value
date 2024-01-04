//
//  User.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation

struct FVUser: Identifiable, Hashable, Equatable, Codable {
    var id: String
    let name: String
    let email: String?
    let profilePictureURL: URL? // URL for the user's profile picture
    let bio: String?
    
    var items: [Item]?
    var friendsList: [String]
    var chats: [String]?
    // Other user attributes as needed
}
