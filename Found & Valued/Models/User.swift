//
//  User.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation

struct User: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let email: String?
    let profilePictureURL: URL? // URL for the user's profile picture
    let bio: String?

    // Other user attributes as needed
}
