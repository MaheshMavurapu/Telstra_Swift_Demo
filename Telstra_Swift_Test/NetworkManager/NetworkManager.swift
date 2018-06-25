//
//  NetworkManager.swift
//  Telstra_Swift_Test
//
//  Created by Mahesh Mavurapu on 25/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import Foundation

typealias callbackHandler = (Error?, Any?, HTTPURLResponse?) -> Void

class NetworkManager: NSObject {
    
    // Network Instance
    class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }
    
    // Get Request for List Details
    func fetchDataFromServer(withUrl url: String?, andCompletionHandler completion: @escaping callbackHandler) {
        if let anUrl = URL(string: url ?? "") {
            let task = URLSession.shared.dataTask(with: anUrl) { (data, response, connectionError ) in
                let httpResponse = response as? HTTPURLResponse
                let error: Error? = nil
                var iso: String? = nil
                if let aData = data {
                    iso = String(data: aData, encoding: .isoLatin1)
                }
                let dutf8: Data? = iso?.data(using: .utf8)
                let json = try? JSONSerialization.jsonObject(with: dutf8!, options: []) as? NSDictionary
                DispatchQueue.main.async(execute: {
                    if json != nil {
                        completion(nil, json as Any, httpResponse)
                    } else {
                        if let anError = error {
                            print("error: \(anError)")
                        }
                        completion(nil, nil, httpResponse)
                    }
                })
            }
            task.resume()
        }
    }
    
    // Downloading Image
    func downloadImageFromServer(with imgURL: URL?, andCompletionHandler completion: @escaping callbackHandler) {
        if let anURL = imgURL {
            let task = URLSession.shared.dataTask(with: anURL) { (data, response, connectionError ) in
                let httpResponse = response as? HTTPURLResponse
                if connectionError == nil {
                    completion(nil, data, httpResponse)
                } else {
                    completion(connectionError, nil, httpResponse)
                    if let anError = connectionError {
                        print("\(anError)")
                    }
                }
            }
            task.resume()
        }
    }
}
