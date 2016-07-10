//
//  ImageViewController.swift
//  Townhero
//
//  Created by Mohamed on 7/9/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false) { 
            
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
