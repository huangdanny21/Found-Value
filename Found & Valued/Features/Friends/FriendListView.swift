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
    
    @Binding var isPresentingFriendList: Bool // Binding property to control dismissal
    @Binding var selectedFriend: FVUser?     // Binding property to communicate selected friend
    
    // Other view code remains the same...
    
    var body: some View {
        NavigationView {
            List(friendListViewModel.friendsList) { item in
                Button(item.name) {
                    selectedFriend = item
                    isPresentingFriendList = false // Dismiss the view
                }
            }
            .navigationTitle("Friends")
        }
        .onAppear {
            friendListViewModel.fetchFriendsList()
        }
    }
}
