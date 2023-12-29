//
//  FeedItem.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation

struct FeedItem: Identifiable, ItemData {
    var id: UUID
    var name: String
    var description: String
    var imageURL: URL?
    
    let userID: UUID
    
}
