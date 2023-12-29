//
//  Item.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation

protocol ItemData {
    var id: UUID { get }
    var name: String { get }
    var description: String { get }
    var imageURL: URL? { get set }
}

struct Item: Identifiable, ItemData {
    let id: UUID
    let name: String
    let description: String
    var imageURL: URL?
}
