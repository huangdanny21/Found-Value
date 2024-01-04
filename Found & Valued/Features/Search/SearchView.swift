//
//  SearchView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var searchViewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText, onCommit: {
                    Task {
                        await searchViewModel.fetchUser(withUsername: searchText)
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                List(searchViewModel.users, id: \.self) { user in
                    NavigationLink(destination: UserProfileView(userProfileViewModel: UserProfileViewModel(with: user))) {
                        Text(user.name)
                    }
                    .onAppear {
                        // Fetch user profile or additional details as needed
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
}

