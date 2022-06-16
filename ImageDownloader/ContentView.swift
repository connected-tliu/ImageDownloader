//
//  ContentView.swift
//  ImageDownloader
//
//  Created by Tak Liu on 2022-06-14.
//

import SwiftUI

struct ContentView: View {
    @State private var source: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Link?", text: $source)
                        // 1. delegate to track on change
                } header: {
                    Text("Image Link")
                }
                
                Section {
                    if URLHelper.verifyUrl(urlString: source) {
                        RemoteImage(source: URL(string: source)!)
//                        RemoteImage(source: source)
                    }
                } header: {
                    Text("Image")
                }
            }
            .navigationTitle("ImageLoader")
        }
        
//        RemoteImage(sources: [
//            URLRequest(url: URL(string: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo-1536x864.jpg")!),
//            URLRequest(url: URL(string: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo-1977-1536x864.png")!),
//            URLRequest(url: URL(string: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo-1976.png")!),
//        ])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
