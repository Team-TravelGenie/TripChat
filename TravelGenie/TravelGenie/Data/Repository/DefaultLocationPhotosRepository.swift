//
//  DefaultLocationPhotosRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/26.
//

import Foundation

final class DefaultLocationPhotosRepository: LocationPhotoRepository {
    
    private let provider = MultiMoyaProvider()
    
    func searchPhoto(
        locationID: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
    {
        let requestModel = LocationPhotosRequestModel(language: languageCode.photosSearchCode, locationId: locationID)
        
        provider.request(.target(TripadvisorLocationPhotosAPI.locationPhotos(requestModel))) {
            let result = $0.mapError { error -> ResponseError in
                return .moyaError(error)
            }.flatMap { response -> Result<String, ResponseError> in
                do {
                    let dto = try response.map(TripadvisorLocationPhotosAPI.ResultType.self)
                    
                    if let imageURL = dto.data.first?.images.large.url {
                        return .success(imageURL)
                    }
                    
                    return .failure(.emptyResponse)
                } catch {
                    return .failure(.moyaError(.jsonMapping(response)))
                }
            }
            
            completion(result)
        }
    }
}
