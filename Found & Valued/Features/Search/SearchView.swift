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
                    searchViewModel.searchUser(withUsername: searchText)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                List(searchViewModel.searchResults, id: \.self) { username in
                    NavigationLink(destination: UserProfileView(userProfileViewModel: UserProfileViewModel(with: username))) {
                        Text(username)
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

