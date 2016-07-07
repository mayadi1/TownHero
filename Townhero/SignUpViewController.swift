//
//  SignUpViewController.swift
//  Townhero
//
//  Created by Cindy Barnsdale on 7/6/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var zipField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        
    }
    
   
    @IBAction func alreadyHaveAccountPressed(sender: AnyObject) {
        if((self.presentingViewController) != nil){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! CreateAccountViewController
        
        dvc.passNameField = nameField.text
        dvc.passAddressField = addressField.text
        dvc.passZipField = zipField.text
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
