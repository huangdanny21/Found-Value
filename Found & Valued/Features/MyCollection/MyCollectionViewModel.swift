//
//  MyCollectionViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import FirebaseAuth

class MyCollectionViewModel: ObservableObject {
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
                return Item(id: UUID(uuidString: idString) ?? UUID(), name: name, description: description, imageURL: url)
            }
        }
    }

    
    // Function to upload item with image to Firestore
    func uploadItemToFirestore(item: Item, image: UIImage) {
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
                    self.items.append(newItem)
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
            "description": itemDescription,
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

}
