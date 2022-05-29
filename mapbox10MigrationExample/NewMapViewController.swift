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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeMapView()
    }
    
    func initializeMapView() {
        guard mapView == nil else { return }
        
        mapView = MapView(frame: view.bounds)
        guard let mapView = mapView else { return }
        
        view.addSubview(mapView)
    }
}
