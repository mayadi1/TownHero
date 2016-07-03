//
//  EditLocationVC.swift
//  Townhero
//
//  Created by Pasha Bahadori on 6/28/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditLocationVC: UIViewController {
 
    @IBOutlet weak var homeAddress: UITextField!
    @IBOutlet weak var workAddress: UITextField!
    
    @IBOutlet weak var currentLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        currentLocationButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        currentLocationButton.layer.cornerRadius = 5
        currentLocationButton.layer.borderWidth = 1
        currentLocationButton.layer.borderColor = UIColor.blackColor().CGColor

    }
    
    
    @IBAction func setCurrentLocation(sender: UIButton) {
   
    }
    
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem) {
        
        
    }
    
    
    
    
    
    
/* WORK IN PROGRESS: 
 1. How do I prevent a user from saving an invalid Zipcode? (Characters entered in the string must be 0-9, and cannot be more or less than 5 characters)
 
 2. Save the user's zipcode as their current location
 */

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
