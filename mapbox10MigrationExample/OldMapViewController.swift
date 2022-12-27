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
        
    }
    
    func showPoiAsLayer() {
        let feature = MGLPointFeature()
        feature.coordinate = CLLocation(latitude: 50.6710, longitude: 20.2990).coordinate
        feature.attributes = ["name": "image-propertie"]
        mapView?.style?.setImage(UIImage(named: "red_pin")!, forName: "image-propertie")
        if let source = mapView?.style?.source(withIdentifier: "poi-source") as? MGLShapeSource {
            let newShape = MGLShapeCollectionFeature(shapes: [feature])
            source.shape = newShape
        } else {
            let source = MGLShapeSource(identifier:"poi-source", features: [feature], options: nil)
            mapView?.style?.addSource(source)
        }
        guard let sourceNew = mapView?.style?.source(withIdentifier: "poi-source"), mapView?.style?.layer(withIdentifier: "poi-layer") == nil else {
            return
        }
        let poiLayer = MGLSymbolStyleLayer(identifier: "poi-layer", source: sourceNew)
        poiLayer.iconImageName = NSExpression(forConstantValue: "{name}")
        mapView?.style?.addLayer(poiLayer)
    }
}

extension OldMapViewController: MGLMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        showPoiAsLayer()
    }
}
