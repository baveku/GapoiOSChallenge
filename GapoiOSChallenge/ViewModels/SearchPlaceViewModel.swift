//
//  SearchPlaceViewModel.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/16/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SearchPlaceViewModel: BaseViewModel {
    // MARK: Public
    var query = BehaviorRelay<String>(value: "")
    var places = BehaviorRelay<[Place]>(value: [])
    
    // MARK: Init
    init(repo: GoogleMapRepository = GoogleMapRepository()) {
        self.repository = repo
    }
    
    // MARK: Private
    private var repository = GoogleMapRepository()
    
    // MARK: Call Services
    func searchPlace() {
        self.repository.searchPlace(text: self.query.value).subscribe(onNext: { (resp) in
            self.places.accept(resp.results)
        }, onError: { (err) in
            self.error.onNext(err.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
}
