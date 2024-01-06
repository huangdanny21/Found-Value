//
//  MyPostsViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/5/24.
//

import SwiftUI

class MyPostsViewModel: ObservableObject {
    @Published var myPosts: [Post] = []
    
    func fetchPosts() async {
        do {
            let posts = try await MyPostsService.fetchPostsForCurrentUser()
            DispatchQueue.main.async {
                self.myPosts = posts
                print("Fetched MyPost count: \(posts.count)")
            }
        } catch {
            print("Failed to fetch posts: \(error.localizedDescription)")
        }
    }
}
