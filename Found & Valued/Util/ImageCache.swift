//
//  ImageCache.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func getImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            return Just(image).eraseToAnyPublisher()
        } else {
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .handleEvents(receiveOutput: { [weak self] image in
                    if let image = image {
                        self?.cache.setObject(image, forKey: url.absoluteString as NSString)
                    }
                })
                .eraseToAnyPublisher()
        }
    }
}

struct CachedImageView: View {
    let url: URL
    let imageCache: ImageCache
    @State private var image: UIImage?
    @State private var cancellable: AnyCancellable?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable() // Make sure to add resizable() here
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width, height: 100) // Adjust size as needed
            } else {
                ProgressView()
                    .onAppear {
                        cancellable = imageCache.getImage(for: url)
                            .receive(on: DispatchQueue.main)
                            .sink { downloadedImage in
                                self.image = downloadedImage
                            }
                    }
                    .onDisappear {
                        cancellable?.cancel()
                    }
            }
        }
    }
}
