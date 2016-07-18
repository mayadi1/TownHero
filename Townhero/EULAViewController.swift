//
//  EULAViewController.swift
//  Townhero
//
//  Created by Mohamed on 7/17/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class EULAViewController: UIViewController {
    var defaults: NSUserDefaults?


    override func viewDidLoad() {
        super.viewDidLoad()

    }


    
    @IBAction func declineButtonPressed(sender: AnyObject) {
        self.defaults = NSUserDefaults.standardUserDefaults()
        let firstLaunch = self.defaults!.boolForKey("FirstLaunch")

        if firstLaunch{
            self.defaults!.setBool(false, forKey: "FirstLaunch")

        }
        
        
        exit(0)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    


}
