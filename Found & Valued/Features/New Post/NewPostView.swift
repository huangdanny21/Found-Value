//
//  NewPostView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI

struct NewPostView: View {
    @ObservedObject var viewModel: NewPostViewModel
    @Environment(\.presentationMode) var presentationMode

    var didCreatePost: (Post?) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Gallery view showing selected images
                GalleryView(imageUrls: [], images: viewModel.selectedImages, showImages: true)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                
                TextView("Description", text: $viewModel.postText)
                
//                // Add tags for the post
//                TextField("Add tags for your post", text: $viewModel.postText)
//                    .padding()
//
//                // Tag users in the post
//                TextField("Tag users in your post", text: $viewModel.postText)
//                    .padding()
                
                Divider()
                
                // Share button
                Button(action: {
                    Task {
                        let post = await viewModel.createNewPost()
                        didCreatePost(post)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Share")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            )
        }
    }
}
