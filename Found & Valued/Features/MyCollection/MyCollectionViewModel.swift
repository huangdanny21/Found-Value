//
//  MyCollectionViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MyCollectionViewModel: ObservableObject {
    @Published var items: [Item] = []

    private var db = Firestore.firestore()

    // Fetch items from Firebase for the MyCollection
    func fetchItemsFromFirebase() {
        db.collection("items").getDocuments { snapshot, error in
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
                return Item(id: UUID(uuidString: idString) ?? UUID(), name: name, description: description)
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
                    let data: [String: Any] = [
                        "name": item.name,
                        "description": item.description,
                        "imageUrl": imageUrl
                        // Add other properties as needed
                    ]
                    
                    let db = Firestore.firestore()
                    db.collection("items").addDocument(data: data) { error in
                        if let error = error {
                            print("Error adding document: \(error.localizedDescription)")
                        } else {
                            print("Item added to Firestore with image URL.")
                            // Item added successfully, perform any required actions
                        }
                    }
                }
            }
        }
    }

}
