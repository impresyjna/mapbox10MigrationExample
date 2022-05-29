//
//  LocationService.swift
//  mapbox10MigrationExample
//
//  Created by Joanna Kasprzycka on 29/05/2022.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let shared: LocationService = LocationService()
    private var locationProvider: CLLocationManager
    var currentLocation: CLLocation?
    
    override init() {
        locationProvider = CLLocationManager()
        super.init()
        locationProvider.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {

    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

    }
}
