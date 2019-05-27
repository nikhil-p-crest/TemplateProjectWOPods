//
//  LocationManager.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    override init() {
        super.init()
    }
    
    static let sharedManager: LocationManager = {
        let instance = LocationManager.init()
        instance.manager.delegate = instance
        instance.manager.desiredAccuracy = kCLLocationAccuracyBest
        return instance
    }()
    
    let manager: CLLocationManager = CLLocationManager.init()
    let geocoder: CLGeocoder = CLGeocoder.init()
    
    var currentLocation: CLLocationCoordinate2D?
    
    var locationUpdateCompletion: ((Bool, CLLocation?, String)->())?
    var authorizationStatusUpdateCompletion: ((CLAuthorizationStatus)->())?
    
}

extension LocationManager {
    
    func requestAuthorization() {
        let authStatus = CLLocationManager.authorizationStatus()
        if (authStatus != .authorizedWhenInUse && authStatus != .authorizedAlways) {
            self.manager.requestWhenInUseAuthorization()
            self.manager.requestAlwaysAuthorization()
        }
    }
    
    fileprivate func permissionStatus() -> Bool {
        
        let authStatus = CLLocationManager.authorizationStatus()
        
        if !CLLocationManager.locationServicesEnabled() {
            return false
        } else {
            if authStatus == .denied || authStatus == .restricted {
                return false
            } else if !(authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways) {
                self.requestAuthorization()
                return false
            } else {
                return true
            }
        }
        
    }
    
    func startMonitoringLocation(_ completion: ((Bool, String)->())? = nil) {
        if self.permissionStatus() == true {
            self.manager.startUpdatingLocation()
            completion?(true, "")
        } else {
            completion?(false, "Location service not enabled or permission not provided.")
        }
    }
    
    func address(fromLatitude latitude: String?, longitude: String?, completion: @escaping ((Bool, String, CLPlacemark?)->())) {
        self.address(fromLatitude: latitude?.toDouble(), longitude: longitude?.toDouble(), completion: completion)
    }
    
    func address(fromLatitude latitude: Double?, longitude: Double?, completion: @escaping ((Bool, String, CLPlacemark?)->())) {
        if latitude != nil && longitude != nil {
            self.geocoder.reverseGeocodeLocation(CLLocation.init(latitude: latitude!, longitude: longitude!)) { (arrayCLPlacemark, error) in
                print(error ?? arrayCLPlacemark ?? "")
                if error != nil {
                    completion(false, error!.localizedDescription, nil)
                } else {
                    if let placemark = arrayCLPlacemark?.first {
                        completion(true, "", placemark)
                    } else {
                        completion(false, ServerConstant.WebService.defaultErrorMessage, nil)
                    }
                }
            }
        } else {
            completion(false, "Latitude or longitude not available.", nil)
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        if location != nil {
            self.currentLocation = location!.coordinate
        }
        self.locationUpdateCompletion?(true, location, "")
        self.manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationUpdateCompletion?(false, nil, error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            self.startMonitoringLocation()
        }
        self.authorizationStatusUpdateCompletion?(status)
    }
    
}

