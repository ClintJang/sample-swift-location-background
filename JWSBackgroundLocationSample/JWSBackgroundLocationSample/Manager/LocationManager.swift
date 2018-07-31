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

var count:Float = 0.0 // For TEST

final class LocationManager : NSObject {
    static let shared = LocationManager()
    
    // logTimer is an unnecessary variable. It is intended to verify that your app is working well and is live in the background.
    private var logTimer:Timer = {
        var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            count += 1.0
            print("\(Date())>>>>> Repeat 1 second(\(count))")
            let time:TimeInterval = UIApplication.shared.backgroundTimeRemaining
            if time > 10000000 /*10000000 ? Let's check the value later!*/ { return }
            print(String(format: "\(Date())>>>>> Current background status. The remaining activation times are: (%.0f)s", time))
            //            print(UIApplication.shared.backgroundTimeRemaining)
        })
        RunLoop.current.add(timer, forMode: .commonModes)
        return timer
    }()
    
    private var restartTimer:Timer?
    private var stopTimer:Timer?

    // CLLocationManager
    private lazy var location:CLLocationManager = {
        var location = CLLocationManager()
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //        location.requestWhenInUseAuthorization()
        
        location.pausesLocationUpdatesAutomatically = false
        location.allowsBackgroundLocationUpdates = true
        location.delegate = self

        return location
    }()
    
    override init() {
        super.init()
        
        addNofification()
    }
}

// MARK: - Notification
extension LocationManager {
    func addNofification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationDidEnterBackground() {
        print("\(Date())>>>>> \(#function)!!")
    }
    
    @objc func applicationDidBecomeActive() {
        print("\(Date())>>>>> \(#function)!!")
    }
}

//MARK: public function
extension LocationManager {
    // Start Using LocationManager
    public func start() {
        print("\(Date())>>>>> \(#function)!!")
        
        if CLLocationManager.locationServicesEnabled() == false {
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted {
            print(status)
        } else {
            startUpdatingLocation()
        }
    }
    
    // Use when LocationManager is not used again
    public func stop() {
        print("\(Date())>>>>> \(#function)")
        
        stopUpdatingLocation()
    }
    
    // Restart location info lookup
    public func restart() {
        print("\(Date())>>>>> \(#function)")

        startUpdatingLocation()
    }
}

//MARK: private function
extension LocationManager {
    private func startUpdatingLocation() {
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        location.requestAlwaysAuthorization()
        location.distanceFilter = kCLDistanceFilterNone
    
        location.startUpdatingLocation()
    }
    
    private func stopUpdatingLocation() {
        if self.restartTimer != nil {
            self.restartTimer?.invalidate()
            self.restartTimer = nil
        }
        
        location.stopUpdatingLocation()
    }
    
    private func settingTimer(start:TimeInterval, stop:TimeInterval) {
        // remove restart timer and stop Timer
        removeRestartAndStopTimer()

        // restart Timer
        let restartTimer = Timer.scheduledTimer(withTimeInterval: start, repeats: false, block: { (timer) in
            print("\(Date())>>>>> restartTimer")
            self.restart()
        })
        RunLoop.current.add(restartTimer, forMode: .commonModes)
        self.restartTimer = restartTimer
        
        // Stop Timer
        let stopTimer = Timer.scheduledTimer(withTimeInterval: stop, repeats: false, block: { (timer) in
            print("\(Date())>>>>> stopTimer")
            self.location.stopUpdatingLocation()
        })
        RunLoop.current.add(stopTimer, forMode: .commonModes)
        self.stopTimer = stopTimer
    }
    
    /// remove restart timer and stop Timer
    private func removeRestartAndStopTimer() {
        if self.restartTimer != nil {
            self.restartTimer?.invalidate()
            self.restartTimer = nil
        }
        
        if self.stopTimer != nil {
            self.stopTimer?.invalidate()
            self.stopTimer = nil
        }
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        
        for location:CLLocation in locations {
            let coordinate:CLLocationCoordinate2D = location.coordinate
            let horizontalAccuracy:CLLocationAccuracy = location.horizontalAccuracy
            
            print("latitude : \(coordinate.latitude), longitude: \(coordinate.longitude), Accuracy : \(horizontalAccuracy)")
        }
        
        // Let the background do it!
        BackgroundTaskManager.shared.new()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways {
            // Reset timer time to update location information
            settingTimer(start: 30.0, stop: 10.0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error)
    }
}
