//
//  ImageManager.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/30.
//

import UIKit

final class ImageManager {
    
    static let cache: URLCache = URLCache.shared
    static var dataTask: URLSessionDataTask?
    
    static func retrieveImage(
        with url: String,
        completion: @escaping (Data) -> Void)
    {
        guard let url = URL(string: url) else { return }
        
        let request: URLRequest = URLRequest(url: url)
        if let data = loadImageFromCache(with: request) {
            completion(data)
        } else {
            downloadImage(with: request) { data in
                completion(data)
            }
        }
    }
    
    private static func loadImageFromCache(with request: URLRequest) -> Data? {
        return cache.cachedResponse(for: request)?.data
    }
    
    private static func downloadImage(
        with request: URLRequest,
        completion: @escaping (Data) -> Void)
    {
        dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200..<300) ~= response.statusCode else { return }
            
            ImageCompressor.compress(imageData: data) { compressedImageData in
                guard let compressedImageData else { return }
                
                let cachedResponse: CachedURLResponse = CachedURLResponse(response: response, data: compressedImageData)
                cache.storeCachedResponse(cachedResponse, for: request)
                completion(compressedImageData)
            }

        }
        dataTask?.resume()
    }
}
