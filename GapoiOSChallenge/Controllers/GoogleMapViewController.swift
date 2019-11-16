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
    
    // MARK: IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var fromButton: DesignableButton!
    @IBOutlet weak var toButton: DesignableButton!
    @IBOutlet weak var currenLocationButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingModel()
        bindingAction()
    }

    // MARK: Action
    func onUpdateDirections() {
        self.viewModel.getDirectionFromGoogleMapAPI()
    }

    @IBAction func onSelectLocation(_ sender: DesignableButton) {
        self.performSegue(withIdentifier: EIdentifierSegue.fromGoogleMaptoSeachMap.rawValue, sender: nil)
    }
    
    // MARK: MapView Action
    func updateCamera(to location: Location) {
        let position = GMSCameraPosition(target: location.toCoordinate2D(), zoom: 12)
        self.mapView.animate(with: .setCamera(position))
    }
}

// MARK
extension GoogleMapViewController {
    func bindingModel() {
        self.viewModel.error.subscribe({
            UIAlertController.init(title: "ERROR", message: "\($0)", preferredStyle: .alert).show(self, sender: nil)
        }).disposed(by: self.disposeBag)
        self.viewModel.loading.subscribe { (isLoading) in
            // Handle Loading Event
            print(isLoading)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.cameraLocationPublish.subscribe({ (event) in
            guard let location = event.element else {
                return
            }
            self.updateCamera(to: location)
        }).disposed(by: self.disposeBag)
    }
    
    func bindingAction() {
        self.currenLocationButton.rx.tap.bind {
            self.viewModel.requestCurrentLocation()
        }.disposed(by: self.disposeBag)
    }
}
