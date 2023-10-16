//
//  MultiMoyaProvider.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

final class MultiMoyaProvider: MoyaProvider<MultiTarget> {
    typealias Target = MultiTarget
    
    override init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false
    ) {
        super.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
}

/*
 // MARK: 디버깅메서드 : Json을 prettyPrint Dictionary로 프린트합니다.
 
func jsonToPrettyPrintString(data: Data) {
    if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        
        if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
            // Print the pretty printed JSON string
            print(prettyPrintedString)
        }
    }
}
*/
