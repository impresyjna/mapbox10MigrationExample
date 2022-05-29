//
//  CustomLocationProvider.swift
//  mapbox10MigrationExample
//
//  Created by Joanna Kasprzycka on 29/05/2022.
//

import Foundation
import CoreLocation
import MapboxMaps

public final class CustomLocationProvider: NSObject {
    private var locationProvider: CLLocationManager
    private var privateLocationProviderOptions: LocationOptions {
        didSet {
            locationProvider.distanceFilter = privateLocationProviderOptions.distanceFilter
            locationProvider.desiredAccuracy = privateLocationProviderOptions.desiredAccuracy
            locationProvider.activityType = privateLocationProviderOptions.activityType
        }
    }
    private weak var delegate: LocationProviderDelegate? {
        return customDelegate
    }
    private weak var customDelegate: LocationProviderDelegate?
    var timer: Timer?
    var currentLocation: CLLocation
    private(set) var trackUser: Bool = true
    
    public override init() {
        locationProvider = CLLocationManager()
        privateLocationProviderOptions = LocationOptions()
        currentLocation = CLLocation(latitude: 50.6710, longitude: 20.2990)
        super.init()

        locationProvider.delegate = self
        setupTimer()
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(newLocation), userInfo: nil, repeats: true)
    }
    
    @objc func newLocation() {
        currentLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude + 0.0001, longitude: currentLocation.coordinate.longitude), altitude: currentLocation.altitude, horizontalAccuracy: currentLocation.horizontalAccuracy, verticalAccuracy: currentLocation.verticalAccuracy, course: currentLocation.course + 1, speed: currentLocation.speed + 1, timestamp: Date())

        locationManager(locationProvider, didUpdateLocations: [currentLocation])
    }
    
    func setTrackUser(trackUser: Bool) {
        self.trackUser = trackUser
    }
}

extension CustomLocationProvider: LocationProvider {

    public var locationProviderOptions: LocationOptions {
        get {
            return privateLocationProviderOptions
        }
        set {
            privateLocationProviderOptions = newValue
        }
    }

    public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationProvider.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }

    public var accuracyAuthorization: CLAccuracyAuthorization {
        if #available(iOS 14.0, *) {
            return locationProvider.accuracyAuthorization
        } else {
            return .fullAccuracy
        }
    }

    public var heading: CLHeading? {
        return locationProvider.heading
    }

    public func setDelegate(_ delegate: LocationProviderDelegate) {
        self.customDelegate = delegate
    }

    public func requestAlwaysAuthorization() {
        locationProvider.requestAlwaysAuthorization()
    }

    public func requestWhenInUseAuthorization() {
        locationProvider.requestWhenInUseAuthorization()
    }

    @available(iOS 14.0, *)
    public func requestTemporaryFullAccuracyAuthorization(withPurposeKey purposeKey: String) {
        locationProvider.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey)
    }

    public func startUpdatingLocation() {
        locationProvider.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationProvider.stopUpdatingLocation()
    }

    public var headingOrientation: CLDeviceOrientation {
        set {
            locationProvider.headingOrientation = newValue
        } get {
            return locationProvider.headingOrientation
        }
    }

    public func startUpdatingHeading() {
        locationProvider.startUpdatingHeading()
    }

    public func stopUpdatingHeading() {
        locationProvider.stopUpdatingHeading()
    }

    public func dismissHeadingCalibrationDisplay() {
        locationProvider.dismissHeadingCalibrationDisplay()
    }
}

extension CustomLocationProvider: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard trackUser else { return }
        delegate?.locationProvider(self, didUpdateLocations: locations)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
//        guard trackUser else { return }
        delegate?.locationProvider(self, didUpdateHeading: heading)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        guard trackUser else { return }
        delegate?.locationProvider(self, didFailWithError: error)
    }

    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        guard trackUser else { return }
        delegate?.locationProviderDidChangeAuthorization(self)
    }
}

/// This implementation of LocationProviderDelegate is used by `LocationManager` to work around
/// the fact that the `LocationProvider` API does not allow the delegate to be set to `nil`.
internal class CustomEmptyLocationProviderDelegate: LocationProviderDelegate {
    func locationProvider(_ provider: LocationProvider, didFailWithError error: Error) {}
    func locationProvider(_ provider: LocationProvider, didUpdateHeading newHeading: CLHeading) {}
    func locationProvider(_ provider: LocationProvider, didUpdateLocations locations: [CLLocation]) {}
    func locationProviderDidChangeAuthorization(_ provider: LocationProvider) {}
}
