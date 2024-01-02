//
//  Item.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation

protocol ItemData {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var imageURL: URL? { get set }
    var tagType: [ItemsTag]? { get set }
}

struct Item: Identifiable, ItemData, Equatable, Hashable {
    var tagType: [ItemsTag]?
    let id: String
    let name: String
    let description: String
    var imageURL: URL?
}
