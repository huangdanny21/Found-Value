//
//  Item.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation

struct Item: Identifiable {
    let id: UUID
    let name: String
    let description: String
    var imageURL: URL?
}
