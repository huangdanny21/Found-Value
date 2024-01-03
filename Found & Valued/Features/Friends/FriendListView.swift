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
    
    @Binding var isPresentingFriendList: Bool
    @Binding var selectedFriend: FVUser?
    @StateObject var chatListViewModel: ChatListViewModel // Inject ChatListViewModel
    
    var body: some View {
        NavigationView {
            List(friendListViewModel.friendsList) { item in
                Button(item.name) {
                    selectedFriend = item
                    isPresentingFriendList = false // Dismiss the view
                    
                    // Add a new chat when a friend is selected
                    if let selectedFriend = selectedFriend {
                        chatListViewModel.addChatToFirestore(receiverUser: selectedFriend)
                    }
                }
            }
            .navigationTitle("Friends")
        }
        .onAppear {
            friendListViewModel.fetchFriendsList()
        }
    }
}
