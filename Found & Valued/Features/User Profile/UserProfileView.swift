//
//  UserProfileView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel // Assuming you have a UserProfileViewModel

    var body: some View {
        VStack {
            Text("User Profile")
                .font(.title)
                .padding()

            // Display user profile information
            Text("Username: \(userProfileViewModel.username)")
            Text("Email: \(userProfileViewModel.email)")

            // Add other user profile details as needed

            Spacer()

            Button("Edit Profile") {
                // Functionality to edit the user profile
                // You can implement an edit profile screen or action here
            }
            .padding()
        }
        .onAppear {
            userProfileViewModel.fetchUserProfile() // Fetch user profile details on view appear
        }
    }
}
