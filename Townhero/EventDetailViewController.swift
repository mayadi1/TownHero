
//
//  EventDetailViewController.swift
//  Townhero
//
//  Created by Mohamed on 6/28/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import MapKit


class EventDetailViewController: UIViewController {

    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var passedEvent: Events?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.navigationItem.title = self.passedEvent?.name
        
        self.webView.loadHTMLString("\(self.passedEvent?.des)", baseURL: nil)
        self.dateLabel.text = "\(self.passedEvent?.date)"
        self.whereLabel.text = self.passedEvent?.address
        
        
        
        
        

        
        
        
        
        
    }

    @IBAction func directionButtonPressed(sender: AnyObject) {
    }
   
    
}
