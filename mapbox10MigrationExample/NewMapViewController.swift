//
//  NewMapViewController.swift
//  mapbox10MigrationExample
//
//  Created by Joanna Kasprzycka on 27/05/2022.
//

import Foundation
import UIKit
import MapboxMaps
import MapboxNavigation

class NewMapViewController: UIViewController {
    var navigationMapView: NavigationMapView?
    var mapView: MapView? {
        return navigationMapView?.mapView
    }
    let provider: CustomLocationProvider = CustomLocationProvider()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeMapView()
    }
    
    func initializeMapView() {
        guard mapView == nil else { return }
        
        navigationMapView = NavigationMapView(frame: view.bounds)
//        if let styleUri = StyleURI(rawValue: "mapbox://styles/examples/cke97f49z5rlg19l310b7uu7j") {
//            mapView?.mapboxMap.loadStyleURI(styleUri)
//        }
        
        guard let navigationMapView = navigationMapView else { return }
        
        let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .raw)
        navigationViewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = false
        navigationViewportDataSource.options.followingCameraOptions.centerUpdatesAllowed = true
        navigationViewportDataSource.followingMobileCamera.zoom = 15.0
        navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
        
        view.addSubview(navigationMapView)
        
        setupUserLocation()
    }
    
    func setupUserLocation() {
        let provider: CustomLocationProvider = CustomLocationProvider()
        self.mapView?.location.overrideLocationProvider(with: provider)
        let cameraOptions = CameraOptions(center: CLLocation(latitude: 50.6710, longitude: 20.2990).coordinate, padding: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0), zoom: 15.0)
        self.mapView?.camera.ease(to: cameraOptions, duration: 0.0)
        self.mapView?.mapboxMap.setCamera(to: cameraOptions)
        self.navigationMapView?.userLocationStyle = .courseView()
        provider.setDelegate(self)
    }
    
//    func trackUser() {
//        navigationMapView?.userLocationStyle = .courseView()
//        self.navigationMapView.mapView.location.overrideLocationProvider(with: provider)
//        provider.setDelegate(self)
//    }
    
//    func untrackUser() {
//        navigationMapView.navigationCamera.stop()
//        navigationMapView?.userLocationStyle = .puck2D()
//        provider.setTrackUser(trackUser: false)
//        self.navigationMapView.mapView.location.overrideLocationProvider(with: provider)
//
//        mapTouchTimeout?.invalidate()
//        mapTouchTimeout = Timer.scheduledTimer(
//            withTimeInterval: MapConstants.timeToAutoCenterOnUser,
//            repeats: false
//        ) { [weak self] _ in
//            //            self?.isNavigatingWithoutTrack = false
//            //            self?.setupButtonsForStatus(status: NavigationService.shared.status)
//            //            self?.centerOnUserPosition()
//            self?.trackUser()
//        }
//    }
}

extension NewMapViewController: LocationProviderDelegate {
    func locationProvider(_ provider: LocationProvider, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first, let mapView = mapView else { return }
        navigationMapView?.mapView?.camera.ease(
            to: CameraOptions(center: newLocation.coordinate, padding: UIEdgeInsets(top: 400, left: 0, bottom: 0, right: 0), zoom: 15),
            duration: 1.3)
        
        
        let location = CLLocation(coordinate: newLocation.coordinate,
                                  altitude: 0.0,
                                  horizontalAccuracy: newLocation.horizontalAccuracy,
                                  verticalAccuracy: 0.0,
                                  course: newLocation.course,
                                  speed: 0.0,
                                  timestamp: Date())
        
        if case let .courseView(view) = navigationMapView?.userLocationStyle {
            let point = mapView.mapboxMap.point(for: location.coordinate)
            view.center = point
            view.update(location: location,
                        pitch: mapView.mapboxMap.cameraState.pitch,
                        direction: location.course,
                        animated: true,
                        navigationCameraState: .idle)
        }
    }
    
    func cameraOptions(_ location: CLLocation?) -> [String: CameraOptions] {
        var followingMobileCamera = CameraOptions()
        followingMobileCamera.center = location?.coordinate
        // Set the bearing of the `MapView` (measured in degrees clockwise from true north).
        followingMobileCamera.bearing = 90.0
        followingMobileCamera.padding = .zero
        followingMobileCamera.zoom = 15.0
        followingMobileCamera.pitch = 45.0
        
        let cameraOptions = [
            CameraOptions.followingMobileCamera: followingMobileCamera
        ]
        
        return cameraOptions
    }
    
    
    func locationProvider(_ provider: LocationProvider, didUpdateHeading newHeading: CLHeading) {
        
    }
    
    func locationProvider(_ provider: LocationProvider, didFailWithError error: Error) {
        
    }
    
    func locationProviderDidChangeAuthorization(_ provider: LocationProvider) {
        
    }
}
