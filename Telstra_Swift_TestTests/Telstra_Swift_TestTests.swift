//
//  Telstra_Swift_TestTests.swift
//  Telstra_Swift_TestTests
//
//  Created by Mahesh Mavurapu on 26/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import XCTest
@testable import Telstra_Swift_Test

class Telstra_Swift_TestTests: XCTestCase {
    
    var listViewModel: ItemListViewModel? = ItemListViewModel()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let window = UIWindow(frame: UIScreen.main.bounds)
        listViewModel?.sendListViewController(toViewModel: ListViewController())
        let navController = UINavigationController(rootViewController: (listViewModel?.listViewController)!)
        window.rootViewController = navController
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        listViewModel?.listViewController.performSelector(onMainThread: #selector(UIViewController.loadView), with: nil, waitUntilDone: true)
        listViewModel?.listViewController.viewDidAppear(false)
    }
    
    // Custom Test Methods
    func testTableViewCellCellReuseIdentifier() {
        let listTableViewCell = listViewModel?.tableView((listViewModel?.listViewController.tableView)!, cellForRowAt: IndexPath(row: 0, section: 0)) as? ListTableViewCell
        let reuseIdentifier = "ItemTableViewCell"
        XCTAssertTrue((listTableViewCell?.reuseIdentifier == reuseIdentifier), "Table does not create reusable cells")
    }
    
    func testViewConformsToUITableViewDataSource() {
        XCTAssertTrue((listViewModel?.conforms(to: UITableViewDataSource.self))! , "View does not conform to UITableView datasource protocol")
    }
    
    func testViewConformsToUITableViewDelegate() {
        XCTAssertTrue((listViewModel?.conforms(to: UITableViewDelegate.self))!, "View does not conform to UITableView delegate protocol")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        listViewModel?.listViewController = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
