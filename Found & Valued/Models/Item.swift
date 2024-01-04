//
//  Item.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation
import FirebaseFirestore

protocol ItemData {
    var id: String? { get }
    var name: String { get }
    var description: String { get }
    var imageURL: URL? { get set }
//    var tagType: [ItemsTag]? { get set }
}

struct Item: Identifiable, ItemData, Equatable, Hashable, Codable {
//    var tagType: [ItemsTag]?
    @DocumentID var id: String?
    let name: String
    let description: String
    var imageURL: URL?
}
