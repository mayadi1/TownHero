//
//  EditEmailViewController.swift
//  Townhero
//
//  Created by Pasha Bahadori on 6/28/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class EditEmailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
     

        
    }

    @IBAction func onSaveButtonTapped(sender: UIButton) {
        if isValidEmail(emailTextField.text!) == true {
            print("Valid Email")
        } else {
            print("NOT Valid Email")
        }
    }
    
    func isValidEmail(email2Test:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = email2Test.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        return range != nil ? true : false
    }
    
    
    /* WORK IN PROGRESS:
       1. I have a button called "Save" not showing up on my right-side title bar
     
       2. How can I prevent my users from saving an invalid E-mail Address?
 
    */
    
    
    
    
    
    
//    func validateEmail(candidate: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
//        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
//    }
//    
//    validateEmail("test@google.com")     // true
//    validateEmail("invalid@@google.com") // false


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
