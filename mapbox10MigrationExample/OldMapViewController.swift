//
//  OldMapViewController.swift
//  mapbox10MigrationExample
//
//  Created by Joanna Kasprzycka on 27/05/2022.
//

import Foundation
import UIKit
import Mapbox

class OldMapViewController: UIViewController {
    var mapView: MGLMapView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeMapView()
        showPointAnnotation()
    }
    
    func initializeMapView() {
        guard mapView == nil else {
            return
        }
        
        mapView = MGLMapView(frame: self.view.frame)
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //        if let styleUrl = URL(string: "mapbox://styles/examples/cke97f49z5rlg19l310b7uu7j") {
        //            mapView?.styleURL = styleUrl
        //        }
        
        guard let mapView = mapView else {
            return
        }
        
        self.view.addSubview(mapView)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 50.6710, longitude: 20.2990)
        
        let mapDefaultCamera = MGLMapCamera.init(lookingAtCenter: CLLocationCoordinate2D(latitude: 50.6710, longitude: 20.2990), altitude: 400, pitch: 0, heading: 0)
        mapView.setCamera(mapDefaultCamera, animated: false)
        
        mapView.locationManager.stopUpdatingLocation()
    }
    
    func showPointAnnotation() {
        var pointAnnotations = [MGLPointAnnotation]()
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 50.6710, longitude: 20.2990)
        point.title = "\(50.6710), \(20.2990)"
        pointAnnotations.append(point)
        
        mapView?.addAnnotations(pointAnnotations)
    }
    
    func showCircleAnnotation() {
        var circleAnnotations = [MGLCircleStyleLayer]
    }
}

extension OldMapViewController: MGLMapViewDelegate {
    
}
