//
//  ChannelListView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//


import SwiftUI

struct ChannelListView: View {
    @StateObject var viewModel = ChannelListViewModel()
    @State private var isPresentingFriendList = false
    @State private var selectedFriend: FVUser?
    @State private var newChannelName: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.channels) { channel in
                    NavigationLink(destination: ChatView(channel: channel)) {
                        Text(channel.name)
                    }
                }
            }
            .navigationTitle("Channels")
            .navigationBarItems(trailing: Button(action: {
                isPresentingFriendList = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $isPresentingFriendList, content: {
                FriendListView(userSelected: { selectedFriend = $0 }, isPresentingFriendList: $isPresentingFriendList, selectedFriend: $selectedFriend)
                    .onDisappear {
                        if let friend = selectedFriend {
                            if !newChannelName.isEmpty {
                                // Define your message data here
                                let messageData: [String: Any] = [:] // Add your message data
                                
                                viewModel.addChannelToFirestore(channelName: newChannelName, messageData: messageData) { success, error in
                                    if success {
                                        // Channel added successfully, handle accordingly
                                    } else {
                                        // Handle error
                                        if let error = error {
                                            print("Error adding channel: \(error)")
                                        }
                                    }
                                }
                            }
                        }
                    }
            })
            .onAppear(perform: {
                viewModel.fetchChannels()
            })
        }
    }
}
