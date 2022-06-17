//
//  ContentView.swift
//  ImageDownloader
//
//  Created by Tak Liu on 2022-06-14.
//

import SwiftUI

struct ContentView: View {
    @State private var source: String = ""
    
    @State private var image: UIImage?
    
    @Environment(\.imageLoader) private var imageLoader
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Link?", text: $source)
                } header: {
                    Text("Image Link")
                }
                
                Section {
                    Group {
                        if URLHelper.verifyUrl(urlString: source) {
                            RemoteImage(source: URL(string: source)!)
                        }
                    }
                } header: {
                    Text("Image")
                }
            }
            .navigationTitle("ImageLoader")
        }

    }
    
    func loadImage(at source: URLRequest) async {
        do {
            // pause the update if there are no images
            if let image = try await imageLoader.fetch(source) {
                self.image = image
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
