//
//  Comment.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation

struct Comment: Identifiable, Codable {
    var id: String // ID for the comment
    var username: String // Username associated with the comment
    var userid: String
    let text: String
    // Add other comment properties if necessary
}
