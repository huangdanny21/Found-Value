//
//  ChatView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//

import SwiftUI
import MessageKit
import InputBarAccessoryView
import Firebase

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    init(channel: Channel) {
        self.viewModel = ChatViewModel(channel: channel)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages, id: \.id) { message in
                    MessageView(message: message)
                }
            }
            .padding()
            
            HStack {
                TextField("Enter message", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Send") {
                    viewModel.sendMessage()
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .navigationTitle(viewModel.channel.name)
    }
}

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isCurrentUserMessage(userID: Auth.auth().currentUser?.uid ?? "") {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.leading)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.trailing)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}
