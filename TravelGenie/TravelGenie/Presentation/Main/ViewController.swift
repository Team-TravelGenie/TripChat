//
//  ViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestDetectionImageLabelTest()
        requestDetectionLandmarkTest()
    }
}

// MARK: TestMethod 사용 후 제거
extension ViewController {
    func requestDetectionImageLabelTest() {
        let repo = GoogleVisionRepository()
        let sampleImage = UIImage(named: "samsungGalaxyLogo")!
        let imageToBase64StringEncoding = base64Encoding(image: sampleImage)
        
        repo.requestImageLabelDetection(imageToBase64StringEncoding) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestDetectionLandmarkTest() {
        let repo = GoogleVisionRepository()
        let placeImage = UIImage(named: "charlesBridge")!
        let imageToBase64StringEncoding = base64Encoding(image: placeImage)
        
        repo.requestLandmarkDetection(imageToBase64StringEncoding) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func base64Encoding(image: UIImage) -> String {
        guard let data = image.pngData() else { return "" }
         return data.base64EncodedString()
    }
}
