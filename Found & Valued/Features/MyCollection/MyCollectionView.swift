//
//  MyCollectionView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI

struct MyCollectionView: View {
    @StateObject private var myCollectionViewModel = MyCollectionViewModel()
    @State private var isAddItemViewPresented = false
    @State private var shouldRefresh = false // Add a state variable for refreshing

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(myCollectionViewModel.items) { item in
                        VStack(alignment: .leading) {
                            if let imageURL = item.imageURL {
                                // Load and display the image using URLSession or your preferred library
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100) // Adjust size as needed
                                } placeholder: {
                                    // Placeholder or loading view
                                    ProgressView()
                                }
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
            .navigationBarItems(trailing:
                Button(action: {
                    // Action to add an item (e.g., navigate to a view to add an item)
                    // Add your logic here to perform the action when the plus button is tapped
                    // For example, navigate to a new view to add an item
                isAddItemViewPresented = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isAddItemViewPresented, content: {
                AddItemView(myCollectionViewModel: myCollectionViewModel)
                    .onDisappear {
                        shouldRefresh.toggle() // Toggle the state variable on dismiss of AddItemView
                    }
            })
            .onAppear {
                myCollectionViewModel.fetchItemsFromFirebase() // Fetch items when the view appears
            }
            .onChange(of: shouldRefresh) { _ in
                myCollectionViewModel.fetchItemsFromFirebase() // Fetch items when shouldRefresh changes
            }
        }
    }
}
