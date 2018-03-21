//
//  LocationManager.swift
//  JWSBackgroundLocationSample
//
//  Created by Clint on 2018. 3. 21..
//  Copyright © 2018년 clint. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager : NSObject {
    static let shared = LocationManager()
    
    var location:CLLocationManager
    override init() {
        location = CLLocationManager()
        super.init()
        
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        location.requestWhenInUseAuthorization()
//        location.requestAlwaysAuthorization()

        location.pausesLocationUpdatesAutomatically = false
        location.allowsBackgroundLocationUpdates = true
    }
}

extension LocationManager {
    
    func start() {
        location.startUpdatingLocation()
    }
    
    func stop() {
        location.stopUpdatingLocation()
    }
    
    func restart() {
        
    }
}
extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
}
