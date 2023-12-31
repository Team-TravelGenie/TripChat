//
//  ImageCompressor.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/11.
//

import UIKit

struct ImageCompressor {
    
    static func compress(
        imageData: Data,
        maxByte: Int = 1_024_000,
        completion: @escaping (Data?) -> Void)
    {
        DispatchQueue.global().async {
            guard let image = UIImage(data: imageData),
                  let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else {
                return completion(nil)
            }
            
            var iterationImage: UIImage? = image
            var iterationImageSize = currentImageSize
            var iterationCompression: CGFloat = 1.0
            
            while iterationImageSize > maxByte,
                  iterationCompression > 0.01 {
                let percentageDecrease = getPercentageToDecreaseTo(forDataCount: iterationImageSize)
                let canvasSize = CGSize(
                    width: image.size.width * iterationCompression,
                    height: image.size.height * iterationCompression)
                
                iterationImage = image.resize(width: canvasSize.width, height: canvasSize.height)
                
                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
                    return completion(nil)
                }
                
                iterationImageSize = newImageSize
                iterationCompression -= percentageDecrease
            }
            
            completion(iterationImage?.jpegData(compressionQuality: 1.0))
        }
    }
    
    private static func getPercentageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
        switch dataCount {
        case 0..<5_000_000:
            return 0.03
        case 5_000_000..<10_000_000:
            return 0.1
        default:
            return 0.2
        }
    }
}
