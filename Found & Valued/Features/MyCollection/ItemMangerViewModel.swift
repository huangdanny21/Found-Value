//
//  ItemMangerViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import FirebaseAuth

class ItemMangerViewModel: ObservableObject {
    @Published var items: [Item] = []
    @State var shouldRefresh = false // Add a state variable for refreshing

    private var db = Firestore.firestore()

    // Fetch items from Firebase for the MyCollection
    func fetchItemsFromFirebase() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        db.collection("users").document(currentUserID).collection("items").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching items: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No items found")
                return
            }

            self.items = documents.compactMap { document in
                let data = document.data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let idString = document.documentID
                let urlString = data["imageUrl"] as? String ?? ""
                let url = URL(string: urlString)
                return Item(id: idString, name: name, description: description, imageURL: url)
            }
        }
    }

    // Function to upload item with image to Firestore
    func uploadItemToFirestore(item: Item, image: UIImage, postToPublic: Bool = false) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not convert image to data.")
            return
        }
        
        let storageRef = Storage.storage().reference().child("item_images").child("\(UUID().uuidString).jpg")
        
        // Upload image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            // Get download URL for the uploaded image
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                if let imageUrl = url?.absoluteString {
                    // Save item details and image URL to Firestore
                    
                    let newItem = Item(id: item.id, name: item.name, description: item.description, imageURL: URL(string: imageUrl))
                    
                    self.addItemForCurrentUser(itemName: item.name, itemDescription: item.description, imageUrl: imageUrl)
                    if postToPublic {
                        self.addItemToPublicFeed(itemName: item.name, itemDescription: item.description, imageUrl: imageUrl)
                    }
                    self.createMyPostsCollectionIfNotExists(for: CurrentUser.shared.userID ?? "")
                    self.items.append(newItem)
                }
            }
        }
    }
    
    func createMyPostsCollectionIfNotExists(for userID: String) {
        let db = Firestore.firestore()
        let userPostsRef = db.collection("MyPosts").document(userID)

        userPostsRef.getDocument { document, error in
            if let error = error {
                print("Error checking MyPosts collection: \(error.localizedDescription)")
            } else {
                if let document = document, !document.exists {
                    // MyPosts collection for the user doesn't exist, create it
                    userPostsRef.setData(["postids": []]) { error in
                        if let error = error {
                            print("Error creating MyPosts collection: \(error.localizedDescription)")
                        } else {
                            print("MyPosts collection created successfully")
                        }
                    }
                }
            }
        }
    }
    
    func addItemForCurrentUser(itemName: String, itemDescription: String, imageUrl: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()

        let newItemData: [String: Any] = [
            "itemName": itemName,
            "itemDescription": itemDescription,
            "imageUrl": imageUrl
            // Other item details can be added here
        ]

        // Add a new item document directly under the 'items' subcollection of the current user
        db.collection("users").document(currentUserID).collection("items").addDocument(data: newItemData) { error in
            if let error = error {
                print("Error adding item: \(error.localizedDescription)")
            } else {
                print("Item added successfully")
            }
        }
    }

    func addItemToPublicFeed(itemName: String, itemDescription: String, imageUrl: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()

        let newPostData: [String: Any] = [
            "userID": currentUserID,
            "itemName": itemName,
            "itemDescription": itemDescription,
            "imageURL": imageUrl,
            "timestamp": FieldValue.serverTimestamp() // Use Firestore server timestamp
            // Other item details can be added here
        ]

        // Add a new document directly under the 'Posts' collection in 'PublicFeed'
        db.collection("publicFeed").document("posts").collection("posts").addDocument(data: newPostData) { error in
            if let error = error {
                print("Error adding item to public feed: \(error.localizedDescription)")
            } else {
                print("Item added to public feed successfully")
            }
        }
    }
}
