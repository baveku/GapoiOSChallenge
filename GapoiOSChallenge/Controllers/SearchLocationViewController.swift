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
    
    let refreshControl = UIRefreshControl()
    
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
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchLocationViewController: ViewBindable {
    func bindingUI() {
        self.searchBar.rx.text.orEmpty.debounce(.seconds(1), scheduler: MainScheduler.instance).distinctUntilChanged().subscribe { (str) in
            if let query = str.element {
                self.viewModel.onUpdateQuery(query)
            }
        }.disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(Place.self).subscribe { [weak self] (event) in
            guard let place = event.element else {
                return
            }
            
            self?.viewModel.onSelectedPlace(place)
            self?.performSegue(withIdentifier: UnwindIdentifierSegue.unwindToMap.rawValue, sender: nil)
        }.disposed(by: self.disposeBag)
        
        
    }
    
    func bindingData() {
        
        self.viewModel.places.bind(to: self.tableView.rx.items(cellIdentifier: "PlaceTableViewCell", cellType: PlaceTableViewCell.self)) { (index, place, cell) in
            cell.configure(place: place)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.loading.bind(to: refreshControl.rx.isRefreshing).disposed(by: self.disposeBag)
        
        self.viewModel.error.subscribe({ (event) in
            let alert = UIAlertController.init(title: "ERROR", message: "\(event.element ?? "")", preferredStyle: .alert)
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        self.viewModel.loading.subscribe { (isLoading) in
            // Handle Loading Event
            print(isLoading)
        }.disposed(by: self.disposeBag)
    }
}
