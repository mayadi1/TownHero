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
        if nameField.text != "" && addressField.text != "" && zipField.text != "" {
            
            
            let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            // Uncomment this when we get feed done and add HomeView as the storyboard id.
            
            let CreateAccountViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("CreateLogin")
            
            self.presentViewController(CreateAccountViewController, animated: true, completion: nil)
        } else {
          
            
            let alertController = UIAlertController(title: nil, message: "Missing Fields", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Try Again", style: .Cancel) { (action) in
            }
                alertController.addAction(cancelAction)
        
                self.presentViewController(alertController, animated: true, completion: nil)

        }
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
