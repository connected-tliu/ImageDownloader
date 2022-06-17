//
//  RemoteImage.swift
//  ImageDownloader
//
//  Created by Tak Liu on 2022-06-15.
//

import SwiftUI

struct RemoteImage: View {
    private let source: URLRequest

    @State private var image: UIImage?
    
    @Environment(\.imageLoader) private var imageLoader
    
    init(source: URL) {
        self.init(source: URLRequest(url: source))
    }
    
    init(source: URLRequest) {
        self.source = source
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                Rectangle()
                    .background(Color.red)
            }
        }
        .onAppear() {
            loadImageTask(for: source)
        }
        .onChange(of: source) { newValue in
            loadImageTask(for: newValue)
        }
    
    }
//    source  ->>>> try fetch the image -->>> display UI
    
    func loadImageTask(for request: URLRequest) {
        Task {
            print("loadImageTask: \(request)")
            await loadImage(at: request)
        }
    }
    
    func loadImage(at source: URLRequest) async {
        do {
            if let image = try await imageLoader.fetch(source) {
                self.image = image
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(source: URL(string: "https://www.perfectlyintune.com/page34/page35/files/apple-logo-0028640x4800029.jpg")!)
    }
}
