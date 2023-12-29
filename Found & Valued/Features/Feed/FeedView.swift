//
//  FeedView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var createPostViewModel = CreatePostViewModel()

    @State private var shouldReloadData = false // State variable to reload data

    var body: some View {
        NavigationView {
            VStack {
                // Display posts in a list or grid view
                Text("Posts will be displayed here")
                    .padding()

                // Button to create a new post
                NavigationLink(destination: CreatePostView()) {
                    Text("Create Post")
                        .padding()
                }
            }
            .navigationTitle("Feed")
            .onAppear {
                // Refresh the feed when this view appears
                shouldReloadData.toggle()
            }
            .sheet(isPresented: $createPostViewModel.isImagePickerPresented) {
                CreatePostView()
            }
        }
    }
}

