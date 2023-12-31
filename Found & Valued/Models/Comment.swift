//
//  Comment.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation

struct Comment: Identifiable {
    var id: String // ID for the comment
    var username: String // Username associated with the comment
    let text: String
    // Add other comment properties if necessary
}
