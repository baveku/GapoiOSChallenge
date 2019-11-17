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
    
    /** Create a search observable
      - parameters: - a query from textinput
      - returns: - List Place from MapSDK
    **/
    func onSearchPlace() {
        guard !self.query.value.isEmpty else {
            return
        }
        self.loading.accept(true)
        self.repository.searchPlace(text: self.query.value).subscribe(onNext: { [weak self] (resp) in
            self?.places.accept(resp.results)
            self?.loading.accept(false)
        }, onError: { [weak self] (err) in
            self?.error.onNext(err.localizedDescription)
            self?.loading.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: Muation
    func onUpdateQuery(_ query: String) {
        self.query.accept(query)
        self.onSearchPlace()
    }
}
