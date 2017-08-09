//
//  LocationUtil.swift
//  FallahCodeSample
//
//  Created by Fallah on 7/5/17.
//  Copyright © 2017 Fallah. All rights reserved.
//

import UIKit
import PromiseKit
import CoreLocation

class LocationUtil {
    static let manager = CLLocationManager()
    
    static var didAllowLocation: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    static func getPermission(containingVC: UIViewController) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
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
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
