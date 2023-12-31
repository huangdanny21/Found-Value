//
//  HomeViewController.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import UIKit
import SwiftUI
import FirebaseAuth

class HomeViewController: UITabBarController {
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardCollectionVC = UIHostingController(rootView: MyCollectionView(onlogout: logout))
        cardCollectionVC.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "square.grid.2x2"), tag: 0)
        
        let feedVC = UIHostingController(rootView: FeedView())
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: 1)
        
        let searchVC = UIHostingController(rootView: SearchView())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
             
        let notificationsVC = UIHostingController(rootView: NotificationView())
        notificationsVC.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 3)

        viewControllers = [cardCollectionVC, feedVC, searchVC, notificationsVC]
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
