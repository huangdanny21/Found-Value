//
//  ChatView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//

import SwiftUI
import MessageKit
import InputBarAccessoryView

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel // Use @StateObject here

    init(chat: Chat) {
        let chatViewModel = ChatViewModel(chat: chat)
        _viewModel = StateObject(wrappedValue: chatViewModel)
    }
        
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages, id: \.id) { message in
                    MessageView(message: message, isCurrentUser: isCurrentUser(message))
                    Spacer()
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
        .navigationTitle(viewModel.chat.receiverName ?? "Chat")
    }
    
    private func isCurrentUser(_ message: Message) -> Bool {
        message.sender.displayName == CurrentUser.shared.username
    }
}


