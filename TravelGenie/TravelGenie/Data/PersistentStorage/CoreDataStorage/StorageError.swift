//
//  StorageError.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

enum StorageError: Error {
    case coreDataSaveFailure(Error)
}
