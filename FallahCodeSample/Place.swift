//
//  Place.swift
//  FallahCodeSample
//
//  Created by Fallah on 7/6/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import Foundation
import GooglePlaces
import PromiseKit

class Place {
    var photo: Result<GMSPlacePhotoMetadata>!
    var hood: GMSPlaceLikelihood!

    init(hood: GMSPlaceLikelihood, result: Result<GMSPlacePhotoMetadata>) {
        self.hood = hood
        self.photo = result
    }

    
}
