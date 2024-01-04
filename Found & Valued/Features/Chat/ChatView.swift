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

struct MessageView: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    Text(message.sender.displayName)
                        .font(.caption)
                        .foregroundColor(.gray)
                    if let formattedTime = formatDate(message.sentDate) {
                        Text(formattedTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading)
            } else {
                VStack(alignment: .leading) {
                    Text(message.sender.displayName)
                        .font(.caption)
                        .foregroundColor(.gray)
                    if let formattedTime = formatDate(message.sentDate) {
                        Text(formattedTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(message.content)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Format as hours and minutes
        return formatter.string(from: date)
    }
}


