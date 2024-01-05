//
//  NewPostViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI
import YPImagePicker
import FirebaseFirestore
import FirebaseAuth

class NewPostViewModel: ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var postText: String = ""
    
    let service = NewPostService()

    init(selectedImages: [UIImage], postText: String) {
        self.selectedImages = selectedImages
        self.postText = postText
    }
    
    // Function to add images
    func addImages(_ images: [UIImage]) {
        selectedImages.append(contentsOf: images)
    }

    // Function to remove an image
    func removeImage(at index: Int) {
        guard index >= 0, index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }

    // Function to clear all selected images
    func clearImages() {
        selectedImages.removeAll()
    }

    // Function to create a new post
    func createNewPost() async {
        do {
            let post = Post(id: UUID().uuidString, ownerId: Auth.auth().currentUser?.uid ?? "", name: CurrentUser.shared.username ?? "", content: postText, timeStamp: nil, imageUrls: [])
            try await service.createPost(with: selectedImages, post: post)
        } catch {
            print("Failed to create post")
        }
    }
}
