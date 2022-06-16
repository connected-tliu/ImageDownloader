//
//  RemoteImage.swift
//  ImageDownloader
//
//  Created by Tak Liu on 2022-06-15.
//

import SwiftUI

struct RemoteImage: View {
//    private let source: URLRequest
//    @Binding var source: URLRequest
    
    private var sources: [URLRequest]
    @State private var image: UIImage?
    
    @Environment(\.imageLoader) private var imageLoader
    
    init(source: URL) {
        print(source)
        self.init(sources: [URLRequest(url: source)])
    }
    
//    init(source: URLRequest) {
//        self.source = source
//    }
    
    init(sources: [URLRequest]) {
        self.sources = sources
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
        .task {
//            await loadImage(at source)
            await loadImages(at: sources)
        }
    }
    
    
//    source  ->>>> try fetch the image -->>> display UI
    
    func loadImage(at source: URLRequest) async {
        do {
            image = try await imageLoader.fetch(source)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadImages(at sources: [URLRequest]) async {
        for source in sources {
            Task {
                do {
                    image = try await imageLoader.fetch(source)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(source: URL(string: "https://www.perfectlyintune.com/page34/page35/files/apple-logo-0028640x4800029.jpg")!)
    }
}
