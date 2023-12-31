//
//  FriendListView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI

struct FriendListView: View {
    @StateObject var friendListViewModel = FriendListViewModel()

    var body: some View {
        List(friendListViewModel.friendsList, id: \.id) { friend in
            Text("Friend Name: \(friend.name)")
            Text("Friend Email: \(friend.email ?? "")")
            // Display other friend details as needed
        }
        .onAppear {
            friendListViewModel.fetchFriendsList()
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
