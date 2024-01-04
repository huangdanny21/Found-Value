//
//  NewPostViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI
import YPImagePicker

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
    func createNewPost() {
        // Perform logic to create a new post using selectedImages and postText
        // This could involve uploading images to a server, saving post text, etc.
        // Implementation depends on your backend or storage mechanism
        // This function will be called when the user wants to publish the post
    }
}
