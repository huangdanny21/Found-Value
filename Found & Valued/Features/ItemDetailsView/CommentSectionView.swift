//
//  CommentSectionView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI

struct CommentSectionView: View {
    let item: Item
    @ObservedObject var itemDetailsViewModel: ItemDetailsViewModel
    @State private var newCommentText = ""

    var body: some View {
        VStack {
            List {
                ForEach(itemDetailsViewModel.comments) { comment in
                    Text(comment.text)
                        .padding()
                }
            }

            HStack {
                TextField("Add a comment", text: $newCommentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Post") {
                    guard !newCommentText.isEmpty else { return }
                    itemDetailsViewModel.addComment(to: item.id, text: newCommentText)
                    newCommentText = ""
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onAppear {
            itemDetailsViewModel.fetchComments(for: item.id)
        }
    }
}
