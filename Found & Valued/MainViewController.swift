//
//  MainViewController.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import UIKit
import SwiftUI
import FirebaseAuth

class MainViewController: UIViewController {

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = Auth.auth().currentUser {
            let homeView = HomeViewController()
            addChild(homeView)
            view.addSubview(homeView.view)
            
            
            // Setup constraints for the SwiftUI view
            homeView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                homeView.view.topAnchor.constraint(equalTo: view.topAnchor),
                homeView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                homeView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                homeView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            // Notify the hosting controller that it has been added
            homeView.didMove(toParent: self)
        } else {
            let swiftUIView = AuthView()
            
            // Create a UIHostingController to embed SwiftUI content in UIKit
            let hostingController = UIHostingController(rootView: swiftUIView)
            
            // Add the SwiftUI view as a child view controller
            addChild(hostingController)
            
            // Add the SwiftUI view's view as a subview to your UIViewController's view
            view.addSubview(hostingController.view)
            
            // Setup constraints for the SwiftUI view
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            // Notify the hosting controller that it has been added
            hostingController.didMove(toParent: self)
        }
    }
}


