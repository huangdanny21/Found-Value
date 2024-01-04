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

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Gallery view showing selected images
                GalleryView(images: viewModel.selectedImages)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                
                // Add tags for the post
                TextField("Add tags for your post", text: $viewModel.postText)
                    .padding()
                
                // Tag users in the post
                TextField("Tag users in your post", text: $viewModel.postText)
                    .padding()
                
                Divider()
                
                // Share button
                Button(action: {
                    viewModel.createNewPost()
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
