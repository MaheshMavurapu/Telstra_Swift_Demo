//
//  GlobalWidget.swift
//  Telstra_Swift_Test
//
//  Created by Mahesh Mavurapu on 25/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import Foundation
import UIKit

typealias actionHandler = (UIAlertController) -> Void

class GlobalWidget: NSObject {
    
    // Alert
    class func alertMessage(_ message: String?, title: String?, andCompletionHandler completion: actionHandler) {
        // Step-1
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        // Step-2
        var rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        if (rootViewController is UINavigationController) {
            rootViewController = (rootViewController as? UINavigationController)?.viewControllers.first
        }
        if (rootViewController is UITabBarController) {
            rootViewController = (rootViewController as? UITabBarController)?.selectedViewController
        }
        rootViewController?.present(alertController, animated: true)
        completion(alertController)
    }
}
