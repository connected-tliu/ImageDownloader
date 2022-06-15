//
//  ContentView.swift
//  ImageDownloader
//
//  Created by Tak Liu on 2022-06-14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RemoteImage(sources: [
            URLRequest(url: URL(string: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo-1536x864.jpg")!),
            URLRequest(url: URL(string: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo-1977-1536x864.png")!),
            URLRequest(url: URL(string: "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo-1976.png")!),
        ])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
