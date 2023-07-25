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
        requestDetectionLandmarkTest()
    }
}

// MARK: TestMethod 사용 후 제거
extension ViewController {
    func requestDetectionImageLabelTest() {
        let repo = GoogleVisionRepository()
        let imageToBase64StringEncoding = base64Encoding()
        
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
        let imageToBase64StringEncoding = base64Encoding()
        
        repo.requestLandmarkDetection(imageToBase64StringEncoding) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func base64Encoding() -> String {
        guard let image = UIImage(named: "samsungGalaxyLogo"),
              let data = image.pngData() else { return "" }
         return data.base64EncodedString()
    }
}
