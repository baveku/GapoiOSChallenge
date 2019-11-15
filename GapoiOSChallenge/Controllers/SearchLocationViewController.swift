//
//  SearchLocationViewController.swift
//  GapoiOSChallenge
//
//  Created by Bách veku on 11/15/19.
//  Copyright © 2019 Bách veku. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initDelegateDataSource()
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
