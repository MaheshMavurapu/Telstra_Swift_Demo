//
//  ItemListAPICall.swift
//  Telstra_Swift_Test
//
//  Created by Mahesh Mavurapu on 25/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import Foundation

protocol ListProtocol: NSObjectProtocol {
    func listOfResults(fromServer detailsList: NSDictionary?, error: Error?, responseCode code: Int)
}

class ItemListAPICall: NSObject {
    
    // MARK:- Properties
    weak var listDelegate: ListProtocol?
    
    // Fetching Item Details
    func getDetailsFromServer(_ url: String?) {
        let networkManager = NetworkManager.sharedInstance
        networkManager.fetchDataFromServer(withUrl: url, andCompletionHandler: { error, response, httpResponse in
            (self.listDelegate?.listOfResults(fromServer: response as? NSDictionary, error: error, responseCode: httpResponse?.statusCode ?? 0))!
        })
    }
}
