//
//  NotificationView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/30/23.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var notificationsViewModel = NotificationsViewModel()

    var body: some View {
        List(notificationsViewModel.notifications) { notification in
            VStack(alignment: .leading) {
                Text("Sender: \(notification.username)")
                Text("Type: \(notification.notificationType.rawValue)")

                // Check if it's a friend request notification
                if notification.notificationType == .friendRequest {
                    HStack {
                        Button("Accept") {
                            notificationsViewModel.acceptFriendRequest(notification.senderID) { success in
                                if success {
                                    // Handle UI update or navigation after accepting the friend request
                                    print("Friend request accepted successfully")
                                } else {
                                    // Handle failure case
                                    print("Failed to accept friend request")
                                }
                            }
                        }
                        .foregroundColor(.green)
                        
                        Button("Deny") {
                            notificationsViewModel.denyFriendRequest(notification)
                        }
                        .foregroundColor(.red)
                    }
                }
                // Add other notification details as needed
            }
            .padding()
        }
        .onAppear {
            notificationsViewModel.fetchNotifications()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
