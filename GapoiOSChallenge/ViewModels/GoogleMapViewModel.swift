//
//  GoogleMapViewModel.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/14/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import RxSwift
import CoreLocation
import GoogleMaps

class GoogleMapViewModel: BaseViewModel {
    private var _repository: GoogleMapRepository = GoogleMapRepository()
    private var _locationManager = CLLocationManager()
    
    // MARK: Public
//    var fromLocation = Variable<CLLocationCoordinate2D>(nil)
//    var toLocation = PublishSubject<CLLocationCoordinate2D>(nil)
    var cameraLocationPublish = PublishSubject<Location>()

    // MARK: Action
    init(repository: GoogleMapRepository = GoogleMapRepository()) {
        super.init()
        self._repository = repository
        self._locationManager.delegate = self
    }
    
    // MARK: API service
    func getDirectionFromGoogleMapAPI() {
        
    }
    
    func updateVehicel() {}
    
    // MARK: Private
    private var _currentLocation: Location? = nil
    
    // MARK: Function
    
    func requestCurrentLocation() {
        self._locationManager.requestLocation()
    }
}

extension GoogleMapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else {
            return
        }
        let coordinate = locations[0].coordinate
        self._currentLocation = Location(coordinate: coordinate)
        self.cameraLocationPublish.onNext(self._currentLocation!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error.onNext(error.localizedDescription)
    }
}
