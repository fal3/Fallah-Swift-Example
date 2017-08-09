//
//  UIImageView+extensions.swift
//  FallahCodeSample
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Wentworth. All rights reserved.
//
import UIKit
import GooglePlaces

typealias UIImageLoadImageCompletionHandler = (Error?) -> Swift.Void

extension UIImageView {
    
    func loadImage(
        with
        photoMetadata: GMSPlacePhotoMetadata,
        completionHandler: @escaping UIImageLoadImageCompletionHandler) {
        
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                completionHandler(error)
            } else {
                DispatchQueue.main.async {
                    self.image = photo
                    completionHandler(nil)
                }
            }
        })
    }

}
