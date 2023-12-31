//
//  HomeViewController.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import UIKit
import SwiftUI
import FirebaseAuth

enum Tabs: Int {
    case cardCollection
    case feed
    case myPosts
    case notifications
    case friends
}

class HomeViewController: UITabBarController {
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardCollectionVC = UIHostingController(rootView: MyCollectionView(onlogout: logout))
        cardCollectionVC.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "square.grid.2x2"), tag: Tabs.cardCollection.rawValue)
        
        let feedVC = UIHostingController(rootView: FeedView())
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: Tabs.cardCollection.rawValue)
             
        let notificationsVC = UIHostingController(rootView: NotificationView())
        notificationsVC.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: Tabs.notifications.rawValue)
        
        let friendsVC = UIHostingController(rootView: FriendListView())
        friendsVC.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.2"), tag: Tabs.friends.rawValue)

        let myPostsVC = UIHostingController(rootView: MyPostsView())
        myPostsVC.tabBarItem = UITabBarItem(title: "My Posts", image: UIImage(systemName: "book"), tag: Tabs.myPosts.rawValue)
        
        viewControllers = [cardCollectionVC, feedVC, notificationsVC, friendsVC, myPostsVC]
    }
    
    func logout() {
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
