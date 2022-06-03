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
    var cameraConsumer: CameraLocationConsumer?
    
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
        if let navigationMapView = navigationMapView {
            self.cameraConsumer = CameraLocationConsumer(mapView: navigationMapView)
            if let cameraConsumer = self.cameraConsumer {
                mapView?.location.addLocationConsumer(newConsumer: cameraConsumer)
            }
        }
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
