//
//  ResetViewController.swift
//  Townhero
//
//  Created by Cindy Barnsdale on 7/1/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase


class ResetViewController: UIViewController {

    
    
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    
        
        
        
    }

  
    @IBAction func recoverPassword(sender: AnyObject) {
        
        
        if <#condition#> {
            <#code#>
        }
        
        
        
        
        
        
        
        
        let invalidPrompt = UIAlertController(title: nil, message: "Invalid Email", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Destructive) { (action) in
            let userInput = self.emailField.text
            if (userInput!.isEmpty) {
               
            } else {
                
                let validPrompt = UIAlertController(title: nil, message: "Email Sent", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Press OK to login", style: UIAlertActionStyle.Default) { (action) in
              
                
            FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                    
                    
                }
            }
        }
    }
            
        }
        invalidPrompt.addAction(cancelAction)
        presentViewController(invalidPrompt, animated: true, completion: nil);
        
        
        
    }
    
    
}
//    FIRAuth.auth()?.sendPasswordResetWithEmail(emailField.text!) { error in
//    
//    if error == nil {
//    print("success")
//    
//    let alertController = UIAlertController(title: nil, message: "Email sent", preferredStyle: .Alert)
//    
//    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//    // ...
//    }
//    alertController.addAction(OKAction)
//    
//    self.presentViewController(alertController, animated: true){
//    
//    }
//    
//    return
//    
//    
//    
//    } else {
//    
//    print(error!.localizedDescription)
//    print(error)
//    print("Error email not sent")
//    }
//    }
//}

