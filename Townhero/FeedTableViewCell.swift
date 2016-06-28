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

    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateTextView: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func config(address: String, title: String, date: Double,des: String){
        
        self.titleLabel.numberOfLines = 0
        
        self.textView.text = des
        self.addressTextView.text = address
        self.titleLabel.text = title
        self.dateTextView.text = "\(date)"
        
        
        
        
        
        
    }
    @IBAction func learnMoreButtonPressed(sender: AnyObject) {
    }
}
