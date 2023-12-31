//
//  PostDetailsView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @StateObject var myPostsViewModel = ItemDetailsViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.item.name)
                .font(.title)
            Text(post.item.description)
                .font(.body)
            
            // Other details of the postSpacer()
            Spacer()
            // Display comment section
            CommentSectionView(item: post.item, itemDetailsViewModel: myPostsViewModel)
                .padding()
        }
        .padding()
        .navigationBarTitle(post.item.name)
    }
}
