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
                    NavigationLink(destination: ChatDetailView(chat: chat)) {
                        VStack(alignment: .leading) {
                            Text("Chat ID: \(chat.id ?? "Unknown")")
                                .font(.headline)
                            Text("Users: \(chat.users.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                    }
                }
                .navigationTitle("Chats")
                .onAppear {
                    chatListViewModel.fetchChatsForCurrentUser()
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
}

struct ChatDetailView: View {
    let chat: Chat

    var body: some View {
        VStack(alignment: .leading) {
            Text("Chat ID: \(chat.id ?? "Unknown")")
                .font(.headline)
            Text("Users: \(chat.users.joined(separator: ", "))")
                .font(.subheadline)

            List(chat.threads) { thread in
                VStack(alignment: .leading) {
                    Text("Sender: \(thread.senderName)")
                        .font(.headline)
                    Text("Message: \(thread.content)")
                        .font(.subheadline)
                    Text("Sent at: \(thread.created)")
                        .font(.caption)
                }
            }
        }
        .padding()
        .navigationTitle("Chat Detail")
    }
}
