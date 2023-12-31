//
//  UserProfileView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel // Assuming you have a UserProfileViewModel
    @State private var isRequestSent: Bool = false // To track the request status

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
            if let currentUser = Auth.auth().currentUser, let viewedUser = userProfileViewModel.user {
                if currentUser.uid != viewedUser.id {
                    if !userProfileViewModel.areUsersFriends {
                        Button(action: {
                            userProfileViewModel.sendFriendRequest { success in
                                if success {
                                    isRequestSent = true
                                } else {
                                    // Handle failure, show an alert or message to the user
                                }
                            }
                        }) {
                            Text(isRequestSent ? "Request Sent" : "Add Friend")
                                .foregroundColor(.white)
                                .padding()
                                .background(isRequestSent ? Color.gray : Color.blue)
                                .cornerRadius(8)
                        }
                        .disabled(isRequestSent) // Disable button if request is already sent
                        .padding()
                    }
                }
            }
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
        }
        .onAppear {
            if let user = userProfileViewModel.user {
                userProfileViewModel.fetchUserItems(for: user)
            }
        }
    }
}

