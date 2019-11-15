//
//  GoogleMapViewController.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/14/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    // MARK: IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var fromButton: DesignableButton!
    @IBOutlet weak var toButton: DesignableButton!
    
    // MARK: Lifecycle
//    let viewModel = GoogleMap
    func initViewModel() {}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.onFindCurrentLocation()
    }
    
    override func loadView() {
        super.loadView()
        
    }

    // MARK: Action
    func onUpdateDirections() {
        
    }
    
    @IBAction func onFindCurrentLocation() {
        self.locationManager.requestLocation()
    }
    @IBAction func onSelectLocation(_ sender: DesignableButton) {
        self.performSegue(withIdentifier: EIdentifierSegue.fromGoogleMaptoSeachMap.rawValue, sender: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else {
            return
        }
        let currentCameraPosition = GMSCameraPosition(target: locations[0].coordinate, zoom: 12)
        self.mapView.camera = currentCameraPosition
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
