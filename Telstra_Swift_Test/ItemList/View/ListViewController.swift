//
//  ListViewController.swift
//  Telstra_Swift_Test
//
//  Created by Mahesh Mavurapu on 25/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController { // Inheritance
    
    // MARK:- Properties
    var tableView: UITableView!
    var activityIndicatorView: UIActivityIndicatorView!
    var itemsList = [ItemListModel]() // Fetched Items List
    var refreshControl: UIRefreshControl!
    var itemListViewModel: ItemListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemListViewModel = ItemListViewModel()
        itemListViewModel.sendListViewController(toViewModel: self)
        // Creating View and Model as ViewModel reference.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        itemListViewModel.addTableView()
        // Adding TableView programmatically - Not using IB.
        if itemListViewModel.listViewController?.itemsList.count == 0 {
            itemListViewModel.fetchDetails()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
