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
        requestTest()
    }
}

// MARK: TestMethod 사용 후 제거
extension ViewController {
    func requestTest() {
        let repo = DefaultRepository()
        let imageToBase64StringEncoding = base64Encoding()
        
        repo.requestDetectedImageLabel(imageToBase64StringEncoding) { result in
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
