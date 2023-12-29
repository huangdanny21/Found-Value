//
//  CreatePostView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct CreatePostView: View {
    @ObservedObject var createPostViewModel = CreatePostViewModel()
    @State private var isCreatePostPresented = false
    @State var isImagePickerPresented = false
    @Environment(\.presentationMode) var presentationMode

    var isAddButtonEnabled: Bool {
        return !createPostViewModel.itemTitle.isEmpty &&
               !createPostViewModel.itemDescription.isEmpty &&
               createPostViewModel.selectedImage != nil
    }

    
    var body: some View {
        VStack {
            // Image placeholder or selected image
            Button(action: {
                isImagePickerPresented = true
            }) {
                if let image = createPostViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                } else {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $createPostViewModel.selectedImage)
            }

            // Text fields for item title and description
            TextField("Item Title", text: $createPostViewModel.itemTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Item Description", text: $createPostViewModel.itemDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Button to post the item
            Button("Post") {
                createPostViewModel.postItem {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .disabled(!isAddButtonEnabled)
            .padding()
        }
        .padding()
        .gesture(DragGesture().onChanged { _ in
            presentationMode.wrappedValue.dismiss()
        })
        .navigationTitle("Create Post")
        // Image picker sheet
        .sheet(isPresented: $createPostViewModel.isImagePickerPresented) {
            ImagePicker(selectedImage: $createPostViewModel.selectedImage)
        }
    }
}

