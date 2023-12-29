//
//  CreatePostViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var itemTitle = ""
    @Published var itemDescription = ""
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented = false
    
    @Published var feedItems: [FeedItem] = [] // Assuming FeedItem is your model for feed posts
    
    func fetchFeeds() {
            let db = Firestore.firestore()
            db.collection("PublicFeed").document("Posts").collection("Posts").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching feed items: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No feed items found")
                    return
                }

                self.feedItems = documents.compactMap { document in
                    let data = document.data()
                    // Create a FeedItem object from the retrieved data
                    // Example:
                    let itemTitle = data["itemTitle"] as? String ?? ""
                    let itemDescription = data["itemDescription"] as? String ?? ""
                    let imageURL = data["imageURL"] as? String ?? ""
                    let id = data["userID"] as? String ?? ""
                    return FeedItem(id: id, itemTitle: itemTitle, itemDescription: itemDescription, imageURL: imageURL)

                }
            }
        }

    func postItem(completion: @escaping () -> Void) {
            guard let currentUser = Auth.auth().currentUser else {
                print("User not authenticated")
                return
            }

            guard let imageData = selectedImage?.jpegData(compressionQuality: 0.5) else {
                print("No image selected")
                return
            }

            let imageID = UUID().uuidString // Generate a unique ID for the image
            let storageRef = Storage.storage().reference().child("item_images/\(imageID).jpg")

            // Upload the image to Firebase Storage
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                guard let _ = metadata else {
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                    }
                    return
                }

                // Get the download URL for the uploaded image
                storageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                        }
                        return
                    }

                    // Create a dictionary with post details
                    let postDetails: [String: Any] = [
                        "userID": currentUser.uid,
                        "itemTitle": self.itemTitle,
                        "itemDescription": self.itemDescription,
                        "imageURL": downloadURL.absoluteString,
                        "timestamp": Timestamp() // Firebase server timestamp
                    ]

                    // Add the post details to the Firestore "Posts" collection
                    let db = Firestore.firestore()
                    db.collection("PublicFeed").document("Posts").collection("Posts").addDocument(data: postDetails) { error in
                        if let error = error {
                            print("Error adding document: \(error.localizedDescription)")
                        } else {
                            print("Post added successfully")
                            completion()
                        }
                    }
                    
                }
            }
        }
}
