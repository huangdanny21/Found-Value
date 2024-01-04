//
//  NewPostService.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import Foundation
import UIKit

protocol NewPostServiceProtocol {
    func storeImages(images: [UIImage], completionHandler: @escaping (Result<[String], Error>) -> Void)
    func createNewPost(withImageUrls urls: [String], post: Post)
}

struct NewPostService: NewPostServiceProtocol {
    func storeImages(images: [UIImage], completionHandler: @escaping (Result<[String], Error>) -> Void) {
        
    }
    
    func createNewPost(withImageUrls urls: [String], post: Post) {
        
    }
}
