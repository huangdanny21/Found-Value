//
//  MessageView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI
import MessageKit
import InputBarAccessoryView
import Firebase

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
