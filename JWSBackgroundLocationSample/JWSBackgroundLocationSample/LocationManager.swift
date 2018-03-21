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
    var logTimer:Timer? // 단순 로그용
    
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
        
        // 백그라운드에서 스래드 살아있나?
        self.logTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            print("logTimer")
            let time:TimeInterval = UIApplication.shared.backgroundTimeRemaining
            if time > 10000000 /*값체크는 나중에*/ { return }
            print(String(format: "Current background status. The remaining activation times are: (%.0f)s", time))
            print(UIApplication.shared.backgroundTimeRemaining)
        })
    }
}

extension LocationManager {
    
    // 처음 시작
    func start() {
        print(Date())
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
        print(Date())   // 시작 시간
        print(#function)
        
        if self.restartTimer != nil {
            self.restartTimer?.invalidate()
            self.restartTimer = nil
        }
        
        location.stopUpdatingLocation()
    }
    
    // 재시작~
    func restart() {
        print(#function) // 종료 시간
        
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
        // 백그라운드가 가능하게
        BackgroundTaskManager.shared.beginNewTask()
        
        if self.restartTimer != nil {
            return
        }
        
        // 재시작 타이머
        if self.restartTimer == nil {
            self.restartTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false, block: { (timer) in
                print("restartTimer")
                self.restart()
            })
        }
        
        if self.stopTimer != nil {
            self.stopTimer?.invalidate()
            self.stopTimer = nil
        }
        
        // 스탑 타이머
        self.stopTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { (timer) in
            print("stopTimer")
            self.location.stopUpdatingLocation()
        })
    }
}
