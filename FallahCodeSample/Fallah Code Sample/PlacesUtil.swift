//
//  PlacesUtil.swift
//  FallahLevelUp
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import GooglePlaces
import GooglePlacePicker
import PromiseKit

class PlacesUtil {
    
    static func fetchPlaces() -> Promise<[GMSPlaceLikelihood]> {
        return Promise { fulfill, reject in
            let currentPlace = GMSPlacesClient()

            currentPlace.currentPlace {
                (ls: GMSPlaceLikelihoodList?, error: Error?) in
                
                if let er = error {
                    reject(er)
                    return
                }
                
                guard let list = ls else {
                    fulfill([])
                    return
                }
                
                fulfill(list.likelihoods)
                
            }
        }
    }
    
    static func fetchPhotosForPlaces(likelihoods: [GMSPlaceLikelihood])
        -> Promise<[GMSPlacePhotoMetadata]> {
            return Promise { fulfill, reject in
                
                var photos = [Promise<GMSPlacePhotoMetadata>]()
                
                for hood in likelihoods {
                    let placeID = hood.place.placeID
                    
                    photos.append(PlacesUtil.fetchPhotoForPlace(placeID: placeID))
                }
                
                when(fulfilled: photos).then { pics in
                    fulfill(pics)
                    }.catch { er in
                        reject(er)
                }
            }
    }

    private static func fetchPhotoForPlace(placeID: String) -> Promise<GMSPlacePhotoMetadata> {
        return Promise { fulfill, reject in
            
            GMSPlacesClient.shared().lookUpPhotos(
                forPlaceID: placeID,
                callback: { (pMD: GMSPlacePhotoMetadataList?, error: Error?) in
                    
                    if let er = error {
                        reject(er)
                        return
                    } else {
                        if let firstPhoto = pMD?.results.first {
                            fulfill(firstPhoto)
                        }
                    }

            })
        }
    }

}
