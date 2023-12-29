//
//  SearchView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var searchQuery = ""
    @State private var users: [User] = []

    var body: some View {
        VStack {
            TextField("Search Username", text: $searchQuery, onCommit: {
                searchViewModel.searchUser(withUsername: searchQuery)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            List(searchViewModel.searchResults, id: \.self) { username in
                Text(username)
            }
        }
        .onAppear {
            // Additional setup if needed
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
