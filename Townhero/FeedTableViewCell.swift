//
//  FeedTableViewCell.swift
//  Townhero
//
//  Created by Cindy Barnsdale on 6/27/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var whoLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var desLabel: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func config(address: String, title: String, date: Double,des: String){
        
        self.titleLabel.numberOfLines = 2
    
        
        self.dateLabel.text = "\(date)"
        self.addressLabel.text = address
        self.titleLabel.text = title
        
        self.desLabel.loadHTMLString("\(des)", baseURL: nil)
        
        
        
        
    }//End of the dunction config
    
}//End of the class FeedTableViewCell
