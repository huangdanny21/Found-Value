//
//  PermissionRequestViewController.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/4/24.
//

import UIKit
import Photos

class PermissionRequestViewController: UIViewController {
    var permissionGrantedHandler: ((Bool) -> Void)?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Please grant access to photos"
        
        let grantButton = UIButton()
        grantButton.setTitle("Grant Permission", for: .normal)
        grantButton.addTarget(self, action: #selector(grantPermission), for: .touchUpInside)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(grantButton)
    }
    
    @objc private func grantPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                let granted = (status == .authorized)
                self?.permissionGrantedHandler?(granted)
            }
        }
    }
}
