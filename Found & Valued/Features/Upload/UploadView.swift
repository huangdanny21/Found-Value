//
//  UploadView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI

struct UploadView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented = false

    var onCancel: (() -> Void)?
    var createdPost: (NewPostViewModel) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                MediaPicker(selectedImages: $selectedImages, isPickerPresented: $isImagePickerPresented, onCancel: {
                    // Handle cancel action
                    self.onCancel?()
                    self.isImagePickerPresented.toggle() // Dismiss the picker on cancel
                }, onNext: {
                    // Handle next action
                    self.presentNewPostView()
                })
            }
        }
    }
    
    func presentNewPostView() {
        let newPostViewModel = NewPostViewModel(selectedImages: selectedImages, postText: "")
        createdPost(newPostViewModel)
    }
}
