//
//  MediaPicker.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI
import YPImagePicker

struct MediaPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, YPImagePickerDelegate {
        func imagePickerHasNoItemsInLibrary(_ picker :YPImagePicker) {
            
        }
        
        
        let parent: MediaPicker
        init(_ parent: MediaPicker) {
            self.parent = parent
        }
        
        // Implement delegate methods here
        func noPhotos() {
            // Handle case when no photos are available
        }
        
        func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
            // Return true or false based on conditions
            return true
        }
        
        func libraryDidSelect(asset: YPMediaItem) {
            // Handle library asset selection
        }
        
        func didClose(with items: [YPMediaItem]?) {
            // Handle closing the picker
        }
    }

    typealias UIViewControllerType = YPImagePicker
    @Binding var selectedImages: [UIImage]
    @Binding var isPickerPresented: Bool
    
    var onCancel: (() -> Void)?
    var onNext: (() -> Void)?

    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        
        //Common
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "Coding Challenge"
        config.showsPhotoFilters = false
        config.showsCrop = .none
        config.screens = [.library]
        config.startOnScreen = .library
        config.hidesCancelButton = false
        config.hidesStatusBar = true
        config.hidesBottomBar = true
        
        //library
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 10
    
        config.wordings.libraryTitle = "Gallery"
        config.library.skipSelectionsGallery = true
        config.targetImageSize = .cappedTo(size: 1080)
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, didCancel in
            if didCancel {
                self.onCancel?()
                picker.dismiss(animated: true, completion: nil)
            } else {
                for item in items {
                    switch item {
                    case .photo(let photo):
                        self.selectedImages.append(photo.image)
                        print(photo)
                    case .video(let video):
                        print(video)
                    }
                }
                self.onNext?()
            }
        }
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
