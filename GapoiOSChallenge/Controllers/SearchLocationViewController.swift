//
//  SearchLocationViewController.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/15/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class SearchLocationViewController: UIBaseViewController {
    let viewModel = SearchPlaceViewModel()
    
    // MARK: IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initDelegateDataSource()
        self.bindingUI()
        self.bindingData()
    }
    
    func initDelegateDataSource() {
        self.searchBar.delegate = self
        self.searchBar.searchTextField.becomeFirstResponder()
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchLocationViewController: ViewBindingable {
    func bindingUI() {
        self.searchBar.rx.text.orEmpty.debounce(.seconds(2), scheduler: MainScheduler.instance).distinctUntilChanged().subscribe { (str) in
            if let query = str.element {
                self.viewModel.query.accept(query)
                self.viewModel.searchPlace()
            }
        }.disposed(by: self.disposeBag)
        
        self.viewModel.places.bind(to: self.tableView.rx.items(cellIdentifier: "PlaceTableViewCell", cellType: PlaceTableViewCell.self)) { (index, place, cell) in
            cell.configure(place: place)
        }.disposed(by: self.disposeBag)
    }
    
    func bindingData() {
        self.viewModel.error.subscribe({ (event) in
            UIAlertController.init(title: "ERROR", message: "\(event.element ?? "")", preferredStyle: .alert).show(self, sender: nil)
        }).disposed(by: self.disposeBag)
        self.viewModel.loading.subscribe { (isLoading) in
            // Handle Loading Event
            print(isLoading)
        }.disposed(by: self.disposeBag)
    }
}
