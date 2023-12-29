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

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(myCollectionViewModel.items) { item in
                        VStack(alignment: .leading) {
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
            })
            .onAppear {
                myCollectionViewModel.fetchItemsFromFirebase() // Fetch items when the view appears
            }
        }
    }
}
