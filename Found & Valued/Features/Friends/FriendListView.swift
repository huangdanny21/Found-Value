//
//  FriendListView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI

struct FriendListView: View {
    @StateObject var friendListViewModel = FriendListViewModel()
    var userSelected: ((FVUser) -> Void)?

    var body: some View {
        NavigationView {
            List(friendListViewModel.friendsList) { item in
                Button(item.name) {
                    self.userSelected?(item)
                    
                }
            }
            .navigationTitle("Friends")
        }
        .onAppear {
            friendListViewModel.fetchFriendsList()
        }
    }
}
