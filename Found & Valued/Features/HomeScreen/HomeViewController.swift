//
//  HomeViewController.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import UIKit
import SwiftUI
import FirebaseAuth
import Photos

enum Tabs: Int, CaseIterable {
    case cardCollection
    case feed
    case upload
    case notifications
    case chat
}

final class HomeViewController: UITabBarController {
        
    // MARK: View Life Cycle
    
    var previousSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardCollectionVC = UIHostingController(rootView: MyPostsView(onlogout: logout))
        cardCollectionVC.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "square.grid.2x2"), tag: Tabs.cardCollection.rawValue)
        
        let feedVC = UIHostingController(rootView: FeedView())
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: Tabs.cardCollection.rawValue)
        
        let uploadContainerView = PermissionContainerViewController()
        uploadContainerView.isPermissionGranted = checkPermission()
        uploadContainerView.didCreatePost = { created in
            self.createdPost()
        }
        
        uploadContainerView.didCancel = {
            if self.previousSelectedIndex != Tabs.upload.rawValue {
                self.selectedIndex = self.previousSelectedIndex
            }
        }
        
        uploadContainerView.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.circle.fill"), tag: Tabs.upload.rawValue)

        let navController = UINavigationController(rootViewController: uploadContainerView)
        
        let notificationsVC = UIHostingController(rootView: NotificationView())
        notificationsVC.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: Tabs.notifications.rawValue)
            
        let chatListsVC = UIHostingController(rootView: ChatListView())
        chatListsVC.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "person.2"), tag: Tabs.chat.rawValue)

        viewControllers = [cardCollectionVC, feedVC, navController, notificationsVC, chatListsVC]
        
        delegate = self
    }
    
    private func createdPost() {
        DispatchQueue.main.async {
            self.selectedIndex = self.previousSelectedIndex
        }
    }
    
    private func checkPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            return true
        }
        return false
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            // If the user logs out successfully, present the MainViewController again
            let mainViewController = MainViewController()
            UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last?.rootViewController = mainViewController
            UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

struct HomeViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        // Instantiate and return your HomeViewController here
        let homeVC = HomeViewController()
        return homeVC
    }

    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
        // Update the view controller if needed
    }
}

extension HomeViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            let selectedTag = index // Use the tag
            print("Selected tab bar item tag: \(selectedTag)")
            
            if index == Tabs.upload.rawValue {
                // We selected the plus button we dont do anything
            } else {
                previousSelectedIndex = selectedTag
            }
        }
    }
}
