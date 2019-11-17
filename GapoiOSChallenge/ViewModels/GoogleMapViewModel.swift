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
import RxRelay

class GoogleMapViewModel: BaseViewModel {
    enum EPlaceDirection {
        case from
        case to
    }
    private var currentSelectType: EPlaceDirection = .from
    
    private var _repository: GoogleMapRepository = GoogleMapRepository()
    private var _locationManager = CLLocationManager()
    
    // MARK: Public
    var fromPlace = BehaviorRelay<Place?>(value: nil)
    var toPlace = BehaviorRelay<Place?>(value: nil)
    var directionMode = BehaviorRelay<DirectionMode>(value: .driving)
    
    var rawPolyline = PublishSubject<String>()
    var cameraLocationPublish = PublishSubject<Location>()

    // MARK: Action
    init(repository: GoogleMapRepository = GoogleMapRepository()) {
        super.init()
        self._repository = repository
        self._locationManager.delegate = self
    }
    
    // MARK: API service
    func getDirectionFromGoogleMapAPI() {
        guard  self.fromPlace.value != nil && self.toPlace.value != nil else {
            return
        }
        
        let origin = "\(self.fromPlace.value!.geometry.location.lat),\(self.fromPlace.value!.geometry.location.lng)"
        let des = "\(self.toPlace.value!.geometry.location.lat),\(self.toPlace.value!.geometry.location.lng)"
        self._repository.getDirection(origin: origin, destination: des, mode: self.directionMode.value).subscribe(onNext: { (response) in
            guard response.routes.count > 0 else {
                self.error.onNext("Not Found!!")
                return
            }
            
            self.rawPolyline.onNext(response.routes[0].overviewPolyline.points)
        }, onError: { (err) in
            self.error.onNext(err.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: Private
    private var _currentLocation: Location? = nil
    
    // MARK: Function
    func requestCurrentLocation() {
        self._locationManager.requestLocation()
    }
    
    // MARK: Mutation
    func onChangeMode(_ newMode: DirectionMode) {
        guard newMode != self.directionMode.value else {
            return
        }
        
        self.directionMode.accept(newMode)
        self.getDirectionFromGoogleMapAPI()
    }
    
    func onUpdatePlace(place: Place) {
        switch self.currentSelectType {
        case .from:
            self.fromPlace.accept(place)
        case .to:
            self.toPlace.accept(place)
            self.getDirectionFromGoogleMapAPI()
        }
    }
    
    func onUpdateCurrentSelectedType(_ value: EPlaceDirection) {
        self.currentSelectType = value
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
