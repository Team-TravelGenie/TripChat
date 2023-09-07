//
//  FirebaseUserFeedbackStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/05.
//

import FirebaseFirestore

final class FirebaseUserFeedbackStorage: UserFeedbackStroage {
    
    private let database = Firestore.firestore()
    
    func save(
        requestModel: UserFeedbackRequestModel,
        completion: @escaping ((Error?) -> Void))
    {
        let collectionPath = "feedback/"
        var data = requestModel.toDictionary()
        data["sentDate"] = Timestamp(date: Date())
        database.collection(collectionPath).addDocument(data: data) { error in
            completion(error)
        }
    }
}
