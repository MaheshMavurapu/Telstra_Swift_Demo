//
//  ItemListModel.swift
//  Telstra_Swift_Test
//
//  Created by Mahesh Mavurapu on 25/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import Foundation

class ItemListModel: NSObject {
    var title: String?
    var detail: String?
    var imageURL: URL?
    
    init(title: String?, detail: String?, imageURL: URL?) {
        self.title = title
        self.detail = detail
        self.imageURL = imageURL
    }
    
    class func modelObject(withDictionary dict: NSDictionary?) -> ItemListModel {
        var title: String? = ""
        var detail: String? = ""
        var imageURL: URL? = nil
        if (dict?["title"] as? NSNull) != NSNull() || (dict?["description"] as? NSNull) != NSNull() || (dict?["imageHref"] as? NSNull) != NSNull() {
            if (dict?["title"] as? NSNull) != NSNull() {
                title = dict?["title"] as? String
            }
            if (dict?["description"] as? NSNull) != NSNull() {
                detail = dict?["description"] as? String
            }
            if (dict?["imageHref"] as? NSNull) != NSNull() {
                let strImgURLAsString = dict?["imageHref"] as? String
                let imgURL = URL(string: strImgURLAsString ?? "")
                imageURL = imgURL
            }
        }
        return ItemListModel(title: title, detail: detail, imageURL: imageURL)
    }
}
