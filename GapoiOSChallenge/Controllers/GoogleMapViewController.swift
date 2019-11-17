//
//  GoogleMapViewController.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/14/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import UIKit
import GoogleMaps
import RxCocoa
import RxSwift

class GoogleMapViewController: UIBaseViewController {
    let viewModel = GoogleMapViewModel()
    
    lazy var polyline: GMSPolyline = {
        let polyline = GMSPolyline()
        polyline.strokeWidth = 5
        polyline.map = self.mapView
        return polyline
    }()
    
    lazy var currentMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.icon = UIImage(named: "ic_cu_location")?.withTintColor(UIColor.gray)
        return marker
    }()
    
    lazy var fromMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.icon = UIImage(named: "location_pin_blue")
        marker.title = "Start Location"
        marker.map = self.mapView
        
        return marker
    }()
    
    lazy var toMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.icon = UIImage(named: "location_pin")
        marker.title = "End Location"
        marker.map = self.mapView
        
        return marker
    }()
    
    // MARK: IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var fromButton: DesignableButton!
    @IBOutlet weak var toButton: DesignableButton!
    @IBOutlet weak var currenLocationButton: DesignableButton!
    @IBOutlet weak var transitButton: UIButton!
    @IBOutlet weak var drivingButton: UIButton!
    @IBOutlet weak var bicyclingButton: UIButton!
    @IBOutlet weak var walkingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light 
        bindingUI()
        bindingData()
    }

    // MARK: IBAction
    @IBAction func onSelectLocation(_ sender: DesignableButton) {
        let type: GoogleMapViewModel.EPlaceDirection = sender.tag == 0 ? GoogleMapViewModel.EPlaceDirection.from : GoogleMapViewModel.EPlaceDirection.to
        
        self.viewModel.onUpdateCurrentSelectedType(type)
        self.performSegue(withIdentifier: EIdentifierSegue.fromGoogleMaptoSeachMap.rawValue, sender: nil)
    }
    
    @IBAction func changeMode(_ sender: UIButton) {
        onDisableButton(transitButton)
        onDisableButton(drivingButton)
        onDisableButton(bicyclingButton)
        onDisableButton(walkingButton)

        sender.tintColor = UIColor.blue
        
        switch sender.tag {
        case 0:
            self.viewModel.onChangeMode(.transit)
        case 1:
            self.viewModel.onChangeMode(.driving)
        case 2:
            self.viewModel.onChangeMode(.bicycling)
        case 3:
            self.viewModel.onChangeMode(.walking)
        default:
            return
        }
    }
    
    func onDisableButton(_ button: UIButton) {
        button.tintColor = UIColor.blue.withAlphaComponent(0.4)
        button.isSelected = false
    }

    // MARK: Handle UnwindData
    @IBAction func unwindFromSelectLocation(_ sender: UIStoryboardSegue) {
        if sender.source is SearchLocationViewController {
            let source = sender.source as! SearchLocationViewController
            if let place = source.viewModel.placeSelected {
                self.viewModel.onUpdatePlace(place: place)
            }
        }
    }
}

// MARK: ViewBindable
extension GoogleMapViewController: ViewBindable {
    func bindingData() {
        
        // MARK: Handle Error, Loading
        self.viewModel.error.subscribe({
            guard let message = $0.element else {
                return
            }
            let alert = UIAlertController.init(title: "ERROR", message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.loading.subscribe { (isLoading) in
            // Handle Loading Event
            print(isLoading)
        }.disposed(by: self.disposeBag)
        
        // MARK: Place
        self.viewModel.fromPlace.bind { (place) in
            guard let address = place?.address else {
                return
            }
            self.fromButton.setTitle(address, for: .normal)
            self.updateMarker(for: .from, place: place!)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.toPlace.bind { (place) in
            guard let address = place?.address else {
                return
            }
            self.toButton.setTitle(address, for: .normal)
            self.updateMarker(for: .to, place: place!)
        }.disposed(by: self.disposeBag)
        
        // MARK: Polyline
        self.viewModel.rawPolyline.subscribe(onNext: { (raw) in
            self.updatePolyline(rawPath: raw, mode: self.viewModel.directionMode.value)
        }).disposed(by: self.disposeBag)
        
        // MARK: Camera
        self.viewModel.currentLocation.subscribe(onNext: { (location) in
            self.markerUpdatePosition(self.currentMarker, position: location.toCoordinate2D())
            self.updateCamera(to: location)
        }).disposed(by: self.disposeBag)
    }
    
    func bindingUI() {
        self.currenLocationButton.rx.tap.bind {
            self.viewModel.requestCurrentLocation()
        }.disposed(by: self.disposeBag)
    }
}
// MARK: MapView Action
extension GoogleMapViewController {
    func updateCamera(to location: Location, zoom: Float = 12) {
        let position = GMSCameraPosition(target: location.toCoordinate2D(), zoom: zoom)
        self.mapView.camera = position
        self.mapView.animate(with: .setCamera(position))
    }
    
    func updateCameraBetweenTwoPlace() {
        let bounds = GMSCoordinateBounds.init(coordinate: fromMarker.position, coordinate: toMarker.position)
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(20))
        self.mapView.moveCamera(update)
    }
    
    func updatePolyline(rawPath: String, mode: DirectionMode) {
        let path = GMSPath.init(fromEncodedPath: rawPath)
        self.polyline.path = path
        self.polyline.strokeColor = ColorHelpers.fromDirectionMode(mode)
        self.polyline.map = self.mapView
    }
    
    func updateMarker(for type: GoogleMapViewModel.EPlaceDirection, place: Place) {
        let position = place.geometry.location.toCoordinate2D()
        self.updateCamera(to: place.geometry.location, zoom: 18)
        switch type {
        case .from:
            self.markerUpdatePosition(fromMarker, position: position)
        case .to:
            self.markerUpdatePosition(toMarker, position: position)
            self.updateCameraBetweenTwoPlace()
        }
    }
    
    func markerUpdatePosition(_ marker: GMSMarker, position: CLLocationCoordinate2D) {
        marker.map = nil
        marker.position = position
        marker.map = self.mapView
    }
}
