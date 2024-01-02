//
//  TagListView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/31/23.
//

import SwiftUI

import SwiftUI

struct TagListView: View {
    @State var selectedTags: Set<ItemsTag> = []
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List(ItemsTag.allCases, id: \.self) { tag in
                Button(action: {
                    if selectedTags.contains(tag) {
                        selectedTags.remove(tag)
                    } else {
                        selectedTags.insert(tag)
                    }
                }) {
                    HStack {
                        Text(tag.rawValue.capitalized)
                        Spacer()
                        if selectedTags.contains(tag) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Tags")
            .navigationBarItems(trailing:
                Button(action: {
                                        // Perform any necessary actions with the selected tags
                                        
                                        // Dismiss the TagListView
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Done")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                            .padding(.top, 20)
                                    }
            )
        }
    }
}

