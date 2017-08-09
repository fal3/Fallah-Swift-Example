//
//  LocationUtil.swift
//  FallahLevelUp
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import UIKit
import SwiftLocation
import PromiseKit

class LocationUtil {
    static let manager = CLLocationManager()

    static var didAllowLocation: Bool {
        get {
            return (CLLocationManager.authorizationStatus() != .authorizedWhenInUse ? false : true)
        }
    }
    
    static func fetchCurrentLocation() -> Promise<CLLocation> {
        return Promise { fulfill, reject in
            Location.getLocation(
                accuracy: .room,
                frequency: .oneShot,
                success: { (
                    req: LocationRequest,
                    loc: CLLocation)
                    -> (Void) in
                    fulfill(loc) //Success 
            },
                error: { (
                    req: LocationRequest,
                    loc: CLLocation?,
                    error: Error)
                    -> (Void) in
                    reject(error) //Catch Error
            })
        }
    }
    
    static func getPermission(containingVC: UIViewController) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            containingVC.showAlert(
                title: "Location Access Disabled",
                msg: "To use this app please enable location services",
                completion: {
                    LocationUtil.openLocationSettings()
            })
        default: break
        }
    }
    
    private static func openLocationSettings() {
        guard let url = URL(string:UIApplicationOpenSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
