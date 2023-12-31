//
//  MyCollectionView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import UIKit

struct MyCollectionView: View {
    @StateObject private var myCollectionViewModel = MyCollectionViewModel()
    @State private var isAddItemViewPresented = false
    @State private var imageCache = ImageCache.shared
    var onlogout: () -> Void
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(myCollectionViewModel.items) { item in
                        VStack(alignment: .leading) {
                            if let imageURL = item.imageURL {
                                // Load and display the image using URLSession or your preferred library
                                CachedImageView(url: imageURL, imageCache: imageCache)
                            }
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("My Collection")
            .navigationBarItems(leading:
                Button(action: {
                // Action to add an item (e.g., navigate to a view to add an item)
                // Add your logic here to perform the action when the plus button is tapped
                // For example, navigate to a new view to add an item
                onlogout()
            }) {
                Text("Logout")
            }, trailing:             Button(action: {
                // Action to add an item (e.g., navigate to a view to add an item)
                // Add your logic here to perform the action when the plus button is tapped
                // For example, navigate to a new view to add an item
                isAddItemViewPresented = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isAddItemViewPresented, content: {
                AddItemView(myCollectionViewModel: myCollectionViewModel)
                    .onDisappear {
                        self.myCollectionViewModel.shouldRefresh.toggle() // Toggle the state variable on dismiss of AddItemView
                    }
            })
            .onAppear {
                myCollectionViewModel.fetchItemsFromFirebase() // Fetch items when the view appears
            }
            .onChange(of: myCollectionViewModel.shouldRefresh) { _ in
                myCollectionViewModel.fetchItemsFromFirebase() // Fetch items when shouldRefresh changes
            }
        }
    }
}
