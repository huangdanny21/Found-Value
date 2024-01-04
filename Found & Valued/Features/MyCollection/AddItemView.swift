//
//  AddItemView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//
import SwiftUI

struct AddItemView: View {
    @State private var itemTitle = ""
    @State private var itemDescription = ""
    @State private var selectedImage: UIImage?
    @State var isImagePickerPresented = false
    @State private var postToPublicFeed = false
    @State private var selectedTags: Set<ItemsTag> = [] // Add this state to hold selected tags
    
    @Environment(\.presentationMode) var presentationMode

    var myCollectionViewModel: ItemMangerViewModel // Your view model

    var isAddButtonDisabled: Bool {
        return selectedImage == nil || itemTitle.isEmpty || itemDescription.isEmpty
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        } else {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }

                    TextField("Item Title", text: $itemTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Item Description", text: $itemDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Toggle("Post to Public Feed", isOn: $postToPublicFeed)
                        .padding()
                    // Display selected tags as labels or text
                      if !selectedTags.isEmpty {
                          VStack(alignment: .leading, spacing: 8) {
                              Text("Selected Tags:")
                                  .font(.headline)
                              
                              // Display selected tags
                              ForEach(Array(selectedTags), id: \.self) { tag in
                                  Text(tag.rawValue)
                                      .padding(8)
                                      .background(Color.gray.opacity(0.2))
                                      .cornerRadius(8)
                              }
                          }
                          .padding(.top, 20)
                      }
                    NavigationLink(destination: TagListView(selectedTags: selectedTags)) {
                        Text("View Tags")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.bottom, 8)
                    }
                }
            }
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    },
                trailing:
                    Button("Add") {
                        // Perform action to add item to Firestore or perform necessary tasks here
                        // You can use itemTitle, itemDescription, and selectedImage
                        guard let image = selectedImage else {
                             print("Please select an image")
                             return
                         }

                        let newItem = Item(id: UUID().uuidString, name: itemTitle, description: itemDescription)
                        self.myCollectionViewModel.uploadItemToFirestore(item: newItem, image: image, postToPublic: postToPublicFeed)
                        presentationMode.wrappedValue.dismiss()
                        self.myCollectionViewModel.shouldRefresh.toggle()
                    }
                    .disabled(isAddButtonDisabled)
            )
        }
        .gesture(DragGesture().onChanged { _ in
            presentationMode.wrappedValue.dismiss()
        })
        .navigationTitle("Add Item")
    }
    
    init(myCollectionViewModel: ItemMangerViewModel) {
        self.myCollectionViewModel = myCollectionViewModel
    }
}
