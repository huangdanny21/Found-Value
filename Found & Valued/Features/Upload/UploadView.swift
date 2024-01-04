//
//  UploadView.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 1/3/24.
//

import SwiftUI

struct UploadView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false

    var body: some View {
        VStack {
            MediaPicker(image: $selectedImage, isPickerPresented: $isImagePickerPresented, onCancel: {
                // Handle cancel action
            }, onNext: {
                // Handle next action
            })
        }
    }
}
