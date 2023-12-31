//
//  UserProfileView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel // Assuming you have a UserProfileViewModel

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack {
            Text("User Profile")
                .font(.title)
                .padding()

            // Display user profile information
            Text("Username: \(userProfileViewModel.user?.name ?? "")")
            Text("Email: \(userProfileViewModel.user?.email ?? "")")

            // Add other user profile details as needed

            Spacer()

            if !userProfileViewModel.userItems.isEmpty {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(userProfileViewModel.userItems) { item in
                        VStack(alignment: .leading) {
                            if let imageURL = item.imageURL {
                                // Load and display the image using URLSession or your preferred library
                                CachedImageView(url: imageURL, imageCache: ImageCache.shared)
                            }
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding()
            } else {
                Text("No items to display")
            }

            Button("Edit Profile") {
                // Functionality to edit the user profile
                // You can implement an edit profile screen or action here
            }
            .padding()
        }
        .onAppear {
            if let user = userProfileViewModel.user {
                userProfileViewModel.fetchUserItems(for: user)
            }
        }
    }
}

