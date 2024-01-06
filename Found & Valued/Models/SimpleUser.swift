//
//  SimpleUser.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/5/24.
//

import Foundation

struct SimpleUser: Identifiable, Codable {
    let id: String
    let username: String
    let userProfilePic: String?
}
