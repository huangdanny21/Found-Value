//
//  Post.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let content: String
    let timeStamp: String
    let imageUrls: [String]
    var comments: [Comment]?
}
