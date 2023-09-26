//
//  ResponseError.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/26.
//

import Foundation

enum ResponseError: Error {
    case emptyResponse
    case moyaError(MoyaError)
}
