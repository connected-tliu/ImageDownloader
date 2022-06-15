//
//  ImageLoader.swift
//  ImageDownloader
//
//  Created by Tak Liu on 2022-06-15.
//

import Foundation
import UIKit
import SwiftUI

actor ImageLoader {
    private enum LoaderStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }
    
    private var images: [URLRequest: LoaderStatus] = [:]
    
    public func fetch(_ url: URL) async throws -> UIImage {
        let request = URLRequest(url :url)
        return try await fetch(request)
    }
    
    public func fetch(_ request: URLRequest) async throws -> UIImage {
        
        // Status Checking <--------- avoid Reentrancy Problem
        if let status = images[request] {
            switch status {
            case .inProgress(let task):
                return try await task.value
            case .fetched(let image):
                return image
            }
        }
        
        // Exisitence Checking (FileSystem)
        if let image = try self.imageFromFileSystem(for: request) {
            print("Fetch from File System : \(request.url?.path ?? "")")
            images[request] = .fetched(image)
            return image
        }
        
        // Image Retrieving from Network (Online)
        let task: Task<UIImage, Error> = Task {
            print("Fetch from Online : \(request.url?.path ?? "")")
            let (imageData, _) = try await URLSession.shared.data(for: request)
            let image = UIImage(data: imageData)!
            try self.persistImage(image, for: request)
            return image
        }
        
        images[request] = .inProgress(task)
        
        let image = try await task.value
        
        images[request] = .fetched(image)
        
        return image
    }
    
    private func persistImage(_ image: UIImage, for request: URLRequest) throws {
        guard let url = fileName(for: request),
              let data = image.jpegData(compressionQuality: 0.8) else {
            assertionFailure("Unable to generate a local path for \(request)")
            return
        }
        
        // Swift cannot write files and create directory at the same time using "data.write(to:)" statement
        // create a directory in advance
        if !FileManager.default.fileExists(atPath: url.deletingLastPathComponent().absoluteString)  {
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        }

        do {
            try data.write(to: url)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func imageFromFileSystem(for request: URLRequest) throws -> UIImage? {
        guard let url = fileName(for: request) else {
            assertionFailure("Unable to generate a local path for \(request)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    private func fileName(for request: URLRequest) -> URL? {
        guard let fileName = request.url?.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        return documentDirectory.appendingPathComponent(fileName)
    }
    
}

struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue = ImageLoader()
}

extension EnvironmentValues {
    var imageLoader: ImageLoader {
        get {
            self[ImageLoaderKey.self]
        }
        set {
            self[ImageLoaderKey.self] = newValue
        }
    }
}
