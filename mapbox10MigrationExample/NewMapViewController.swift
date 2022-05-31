//
//  NewMapViewController.swift
//  mapbox10MigrationExample
//
//  Created by Joanna Kasprzycka on 27/05/2022.
//

import Foundation
import UIKit
import MapboxMaps

class NewMapViewController: UIViewController {
    var mapView: MapView?
    let provider: CustomLocationProvider = CustomLocationProvider()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeMapView()
    }
    
    func initializeMapView() {
        guard mapView == nil else { return }
        
        mapView = MapView(frame: view.bounds)
//        if let styleUri = StyleURI(rawValue: "mapbox://styles/examples/cke97f49z5rlg19l310b7uu7j") {
//            mapView?.mapboxMap.loadStyleURI(styleUri)
//        }
        
        guard let mapView = mapView else { return }
        
        view.addSubview(mapView)
        
        setupUserLocation()
    }
    
    func setupUserLocation() {
//        self.mapView?.location.overrideLocationProvider(with: provider)
        let cameraOptions = CameraOptions(center: CLLocation(latitude: 0, longitude: 0).coordinate, padding: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0), zoom: 15.0)
        self.mapView?.camera.ease(to: cameraOptions, duration: 0.0)
        self.mapView?.mapboxMap.setCamera(to: cameraOptions)
        self.mapView?.location.options.puckType = .puck2D()
//        provider.setDelegate(self)
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
