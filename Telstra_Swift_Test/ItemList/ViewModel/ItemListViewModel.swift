//
//  ItemListViewModel.swift
//  Telstra_Swift_Test
//
//  Created by Mahesh Mavurapu on 25/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import Foundation
import UIKit

class ItemListViewModel: NSObject {
    
    // MARK:- Properties
    var listViewController: ListViewController!
    var itemListAPICall: ItemListAPICall? // API Call
    var cellIdentifier = "ItemTableViewCell" // Cell Identifier
    
    // MARK:- Methods
    func sendListViewController(toViewModel listViewController: ListViewController?) { // ViewController+View = ViewModel
        self.listViewController = listViewController
        // Spinner
        self.listViewController.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.listViewController.activityIndicatorView?.startAnimating()
        self.listViewController.activityIndicatorView?.hidesWhenStopped = true
        self.listViewController.activityIndicatorView?.color = UIColor.red
        self.listViewController.activityIndicatorView?.center = (self.listViewController?.view.center)!
        self.listViewController.view.addSubview((self.listViewController.activityIndicatorView)!)
        // TableView Set
        self.listViewController.tableView?.dataSource = self
        self.listViewController.tableView?.delegate = self
        // API Call Set & Delegate
        itemListAPICall = ItemListAPICall()
        itemListAPICall?.listDelegate = self
    }
}

// MARK:- UI Updates
extension ItemListViewModel {
    
    // MARK:- Helper Methods - Public
    func addTableView() {
        self.listViewController.tableView = UITableView(frame: self.listViewController.view.bounds, style: .plain)
        self.listViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        // add clear bg color for spinner visible
        self.listViewController.tableView.backgroundColor = UIColor.clear
        // must set delegate & dataSource, otherwise the the table will be empty and not responsive
        self.listViewController.tableView.delegate = self
        self.listViewController.tableView.dataSource = self
        self.listViewController.view.addSubview(self.listViewController.tableView)
        
        self.listViewController.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        let views = ["tableView": self.listViewController.tableView]
        // tableviw auto layout
        self.listViewController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views as Any as! [String : Any]))
        self.listViewController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views as Any as! [String : Any]))
        
        // dynamic height
        self.listViewController?.tableView?.rowHeight = UITableViewAutomaticDimension
        self.listViewController?.tableView?.estimatedRowHeight = 44.0
        self.listViewController?.tableView?.tableFooterView = nil
        // pull down refresh
        self.listViewController?.refreshControl = UIRefreshControl()
        if let aControl = self.listViewController?.refreshControl {
            self.listViewController?.tableView?.addSubview(aControl)
        }
        self.listViewController?.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    // Refreshing Main table
    @objc func refreshTable() {
        listViewController?.itemsList.removeAll()
        listViewController?.tableView?.reloadData()
        fetchDetails()
    }
    
    func updateDetail(_ details: NSDictionary?) {
        if details?["title"] != nil {
            listViewController?.title = details?["title"] as? String
        }
        if listViewController?.itemsList == nil {
            listViewController?.itemsList = [ItemListModel]()
        }
        if details?["rows"] != nil {
            listViewController?.itemsList = []
            let rowItems: [NSDictionary] = details?["rows"] as! [NSDictionary]
            var modelArray = [ItemListModel]()
            for dict in rowItems {
                modelArray.append(ItemListModel.modelObject(withDictionary: dict))
            }
            listViewController?.itemsList = modelArray
        }
        listViewController?.tableView?.reloadData()
    }
}

// MARK:- API CAlls
extension ItemListViewModel : ListProtocol {
    
    func fetchDetails() { // Get All Item Details
        // Url String
        itemListAPICall?.getDetailsFromServer(list_Url) // API Call
    }
    
    // Response - API Call - Delegate Methods
    func listOfResults(fromServer detailsList: NSDictionary?, error: Error?, responseCode code: Int) {
        let weakSelf = listViewController
        // add white bg color for tableview display
        listViewController.tableView.backgroundColor = UIColor.white
        weakSelf?.activityIndicatorView.stopAnimating()
        weakSelf?.tableView.reloadData()
        dispatchDelay(delay: 0.0) {
            weakSelf?.refreshControl.endRefreshing()
        }
        if detailsList != nil {
            updateDetail(detailsList! as NSDictionary)
        } else {
            GlobalWidget.alertMessage("Something went wrong. Please try again", title: "Error", andCompletionHandler: { action in
                print(action)
            })
        }
    }
    
    func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
}

// MARK:- Table View Datasource & Delegate
extension ItemListViewModel : UITableViewDataSource, UITableViewDelegate {
    
    // Table View Datasource & Delegate
    func tableView(_ theTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewController!.itemsList.count
    }
    
    func tableView(_ theTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = theTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ListTableViewCell
        if cell == nil {
            cell = ListTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.titleLabel?.text = ""
        cell?.descriptionLabel?.text = ""
        cell?.itemImageView?.image = nil
        cell?.setDetails(listViewController?.itemsList[indexPath.row])
        return cell!
    }
    
    // when user tap the row, what action you want to perform
    func tableView(_ theTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath.row) row")
    }
}
