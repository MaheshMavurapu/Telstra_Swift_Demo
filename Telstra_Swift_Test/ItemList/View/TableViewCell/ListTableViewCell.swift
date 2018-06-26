//
//  ListTableViewCell.swift
//  Telstra_Swift_Test
//
//  Created by Mahesh Mavurapu on 25/06/18.
//  Copyright © 2018 Mahesh Mavurapu. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    var itemImageView: UIImageView?
    var titleLabel: UILabel?
    var descriptionLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialization code
        itemImageView = UIImageView()
        itemImageView?.backgroundColor = UIColor.lightGray
        contentView.addSubview(itemImageView!)
        // Title
        titleLabel = UILabel()
        titleLabel?.numberOfLines = 0
        contentView.addSubview(titleLabel!)
        // Description
        descriptionLabel = UILabel()
        descriptionLabel?.numberOfLines = 0
        descriptionLabel?.textColor = UIColor.lightGray
        contentView.addSubview(descriptionLabel!)
        
        translatesAutoresizingMaskIntoConstraints = false
        itemImageView?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
        addImageViewLayout()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageViewLayout() {
        let views = ["imageView": itemImageView, "title": titleLabel, "description": descriptionLabel]
        let metrics = ["imageSize": 100.0, "padding": 15.0]
        // Horizontal layouts
        let horizontalImgeandTitle = NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[imageView]-padding-[title]-padding-|", options: [], metrics: metrics, views: views as Any as! [String : Any])
        let horizontalDesc = NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[imageView]-padding-[description]-padding-|", options: [], metrics: metrics, views: views as Any as! [String : Any])
        contentView.addConstraints(horizontalImgeandTitle)
        contentView.addConstraints(horizontalDesc)
        
        // Vertical layouts
        let verticalImageTop = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[imageView]->=padding@500-|", options: [], metrics: metrics, views: views as Any as! [String : Any])
        let verticalTitleandDescription = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[title]-[description]->=padding-|", options: [], metrics: metrics, views: views as Any as! [String : Any])
        contentView.addConstraints(verticalImageTop)
        contentView.addConstraints(verticalTitleandDescription)
        
        // Image Height and Width
        let imageWidth = NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView(imageSize)]", options: [], metrics: metrics, views: views as Any as! [String : Any])
        let imageHeight = NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView(imageSize)]", options: [], metrics: metrics, views: views as Any as! [String : Any])
        itemImageView?.addConstraints(imageWidth)
        itemImageView?.addConstraints(imageHeight)
        // ContentHugging for uilabel auto height
        let aPriority = UILayoutPriority(rawValue: 252)
        titleLabel?.setContentHuggingPriority(aPriority, for: .vertical)
    }
    
    func setDetails(_ item: ItemListModel?) {
        if item?.title != nil {
            titleLabel?.text = item?.title
        }
        if item?.detail != nil {
            descriptionLabel?.text = item?.detail
        }
        if item?.imageURL != nil {
            setImageFrom(item?.imageURL)
        }
    }
    
    // Set Image by downloading from server.
    func setImageFrom(_ imageURL: URL?) {
        getDownloadedImage(fromServer: imageURL)
        // Downloading of Image with Url.
    }
    
    // Downloading of Image
    func getDownloadedImage(fromServer url: URL?) {
        let networkmanager = NetworkManager.sharedInstance
        networkmanager.downloadImageFromServer(with: url, andCompletionHandler: { error, response, httpResponse in
            var image: UIImage? = nil
            if let aResponse = response as? Data {
                image = UIImage(data: aResponse)
            }
            weak var weakSelf = self
            // validate for refresh imageview
            if weakSelf?.itemImageView != nil {
                DispatchQueue.main.async(execute: {
                    weakSelf?.itemImageView?.image = image
                })
            }
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

