//
//  PermissionContainerViewController.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/4/24.
//

import UIKit
import SwiftUI
import Photos

class PermissionContainerViewController: UIViewController {
    var isPermissionGranted = false
    
    var didCreatePost: ((Bool) -> Void)?
    var didCancel: (() -> Void)?
        
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAppropriateView()
    }
    
    // MARK: - Privivate functioons
    
    private func showAppropriateView() {
        if isPermissionGranted {
            let uploadView = UploadView(onCancel: didCancel) { [weak self] viewModel in
                self?.dismiss(animated: true, completion: {
                    self?.showNext(viewModel)
                })
            }

            let hostingController = UIHostingController(rootView: uploadView)
            present(hostingController, animated: true)
        } else {
            let permissionRequestViewController = PermissionRequestViewController()
            permissionRequestViewController.permissionGrantedHandler = { [weak self] granted in
                self?.isPermissionGranted = granted
                self?.showAppropriateView()
            }
            present(permissionRequestViewController, animated: true, completion: nil)
        }
    }
    
    private func showNext(_ viewModel: NewPostViewModel) {
        DispatchQueue.main.async {
            let newPostView = NewPostView(viewModel: viewModel) { post in
                self.didCreatePost?(true)
            }
            let hostingController = UIHostingController(rootView: newPostView)
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}
