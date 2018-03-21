//
//  LocationManager.swift
//  JWSBackgroundLocationSample
//
//  Created by Clint on 2018. 3. 21..
//  Copyright © 2018년 clint. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class LocationManager : NSObject {
    static let shared = LocationManager()
    var logTimer:Timer? // For Logging
    
    var restartTimer:Timer?
    var stopTimer:Timer?

    var location:CLLocationManager
    override init() {
        location = CLLocationManager()
        super.init()
        
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        location.requestWhenInUseAuthorization()

        location.pausesLocationUpdatesAutomatically = false
        location.allowsBackgroundLocationUpdates = true
        
        // active in the background...?
        self.logTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            print("logTimer::\(Date())")
            let time:TimeInterval = UIApplication.shared.backgroundTimeRemaining
            if time > 10000000 /*10000000 ? Let's check the value later!*/ { return }
            print(String(format: "Current background status. The remaining activation times are: (%.0f)s", time))
//            print(UIApplication.shared.backgroundTimeRemaining)
        })
    }
}

extension LocationManager {
    
    // 처음 시작
    func start() {
        print("Start!!:\(Date())")
        print(#function)
        
        if CLLocationManager.locationServicesEnabled() == false {
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted {
            print(status)
        } else {
            location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            location.requestAlwaysAuthorization()
            location.distanceFilter = kCLDistanceFilterNone
            
            // gogo
            location.startUpdatingLocation()
        }
    }
    
    // 다시 사용안할 때 사용
    func stop() {
        print("Stop:\(Date())")
        print(#function)
        
        if self.restartTimer != nil {
            self.restartTimer?.invalidate()
            self.restartTimer = nil
        }
        
        location.stopUpdatingLocation()
    }
    
    func restart() {
        print(#function)
        
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        location.requestAlwaysAuthorization()
        location.distanceFilter = kCLDistanceFilterNone
        
        // gogo
        location.startUpdatingLocation()
    }
}
extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        // Let the background do it!
        BackgroundTaskManager.shared.beginNewTask()
        
        if self.restartTimer != nil {
            self.restartTimer?.invalidate()
            self.restartTimer = nil
        }
        
        // restart Timer
        self.restartTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false, block: { (timer) in
            print(">>>>> restartTimer::\(Date())")
            self.restart()
        })
        
        if self.stopTimer != nil {
            self.stopTimer?.invalidate()
            self.stopTimer = nil
        }
        
        // Stop Timer
        self.stopTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { (timer) in
            print(">>>>> stopTimer::\(Date())")
            self.location.stopUpdatingLocation()
        })
    }
}
