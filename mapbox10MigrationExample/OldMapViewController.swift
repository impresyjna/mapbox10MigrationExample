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
        
        guard let mapView = mapView else {
            return
        }
        
        self.view.addSubview(mapView)
    }
}

extension OldMapViewController: MGLMapViewDelegate {
    
}
