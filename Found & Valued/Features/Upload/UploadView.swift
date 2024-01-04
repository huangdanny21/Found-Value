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

    var body: some View {
        NavigationView {
            VStack {
                MediaPicker(selectedImages: $selectedImages, isPickerPresented: $isImagePickerPresented, onCancel: {
                    // Handle cancel action
                }, onNext: {
                    // Handle next action
                    presentNewPostView()
                })
            }
        }
    }
    
    func presentNewPostView() {
        let newPostViewModel = NewPostViewModel(selectedImages: selectedImages, postText: "")
        let newPostView = NewPostView(viewModel: newPostViewModel)

        let hostingController = UIHostingController(rootView: newPostView)
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController?.present(hostingController, animated: true)
    }
}
