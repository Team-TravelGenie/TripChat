//
//  DecodableTargetType.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

protocol DecodableTargetType: Moya.TargetType {
    associatedtype ResultType: Decodable
}
