//
//  SignUpViewController.swift
//  Townhero
//
//  Created by Salar Kohnechi on 7/6/16.
//  Copyright © 2016 Salar Kohnechi All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var zipField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zipField.delegate = self
        
    }
    
    
    
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        if nameField.text!.characters.count > 2 && addressField.text!.characters.count > 4 && zipField.text!.characters.count > 4 {
            
            
            let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            // Uncomment this when we get feed done and add HomeView as the storyboard id.
            
            let createAccountViewController: CreateAccountViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("CreateLogin") as! CreateAccountViewController
            createAccountViewController.passNameField = nameField.text
            createAccountViewController.passAddressField = addressField.text
            createAccountViewController.passZipField = zipField.text
            
            self.presentViewController(createAccountViewController, animated: true, completion: nil)
        } else {
          
            
            let alertController = UIAlertController(title: nil, message: "Missing or invalid fields", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Try Again", style: .Cancel) { (action) in
            }
                alertController.addAction(cancelAction)
        
                self.presentViewController(alertController, animated: true, completion: nil)

        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 5
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    @IBAction func alreadyHaveAccountPressed(sender: AnyObject) {
        if((self.presentingViewController) != nil){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let dvc = segue.destinationViewController as! CreateAccountViewController
//        
//        dvc.passNameField = nameField.text
//        dvc.passAddressField = addressField.text
//        dvc.passZipField = zipField.text
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}