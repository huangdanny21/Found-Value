//
//  ChatListView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/1/24.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var chatListViewModel = ChatListViewModel()
    @State private var isPresentingFriendList = false
    @State private var selectedFriend: FVUser?
    
    var body: some View {
        NavigationView {
            VStack {
                List(chatListViewModel.chats) { chat in
                    NavigationLink(destination: ChatView(chat: chat)) {
                        VStack(alignment: .leading) {
                            Text(chatTitle(for: chat))
                                .font(.headline)
                        }
                    }
                }

                Button(action: {
                    isPresentingFriendList.toggle()
                }) {
                    Text("View Friend List")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Chats")
            .sheet(isPresented: $isPresentingFriendList) {
                FriendListView(isPresentingFriendList: $isPresentingFriendList, selectedFriend: $selectedFriend, chatListViewModel: chatListViewModel)
                    .environmentObject(FriendListViewModel()) 
            }
        }
        .onAppear {
            chatListViewModel.fetchChatsForCurrentUser()
        }
    }
    
    private func chatTitle(for chat: Chat) -> String {
        if chat.senderName == CurrentUser.shared.username {
            return chat.receiverName ?? ""
        }
        return chat.senderName ?? ""
    }
}
