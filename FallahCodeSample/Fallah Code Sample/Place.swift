//
//  Place.swift
//  FallahLevelUp
//
//  Created by Fallah on 7/6/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import Foundation
import GooglePlaces

class Place {
    var photo: GMSPlacePhotoMetadata!
    var title: String!
    
    init(with title: String, pic: GMSPlacePhotoMetadata?) {
        self.title = title
        guard let p = pic else {
            photo = GMSPlacePhotoMetadata.init()
            return
        }
        photo = p
    }
}
