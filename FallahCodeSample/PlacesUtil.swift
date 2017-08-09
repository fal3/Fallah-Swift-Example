//
//  PlacesUtil.swift
//  FallahCodeSample
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import GooglePlaces
import GooglePlacePicker
import PromiseKit

enum MyError : Error {
    case RuntimeError(String)
}

class PlacesUtil {
    static func fetchPlaces() -> Promise<[GMSPlaceLikelihood]> {
        return firstly {
            PromiseKit.wrap(GMSPlacesClient().currentPlace)
        }.then {
            $0.likelihoods
        }
    }
    
    static func fetchPhotosForPlaces(likelihoods: [GMSPlaceLikelihood]) -> Promise<[Result<GMSPlacePhotoMetadata>]> {
        return when(resolved: likelihoods.map {
            PlacesUtil.fetchPhotoForPlace(placeID: $0.place.placeID)
        })
    }
    
    static func fetchPhotoForPlace(placeID: String) -> Promise<GMSPlacePhotoMetadata> {
        return firstly {
            PromiseKit.wrap{ GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID, callback: $0) }
        }.then {
            guard let first = $0.results.first else {
                throw MyError.RuntimeError("Error")
            }
            return Promise(value: first)
        }
    }
}
