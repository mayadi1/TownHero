//
//  ResetViewController.swift
//  Townhero
//
//  Created by Salar Kohnechi on 7/1/16.
//  Copyright © 2016 Salar Kohnechi. All rights reserved.
//

import UIKit
import Firebase


class ResetViewController: UIViewController {


    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()



    
    }

    @IBAction func recoverPassword(sender: AnyObject) {
       
        FIRAuth.auth()?.sendPasswordResetWithEmail(self.emailField.text!) { error in
            if error == nil {
                print("success")
             
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    let alertController = UIAlertController(title: nil, message: "Reset email sent", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "Login", style: .Default) { (action) in
                        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                        let ViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
                        
                        self.presentViewController(ViewController, animated: true, completion: nil)                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: false){
                        
                    }
                }

            } else {
                
                print(error!.localizedDescription)
                print(error)
                print("Error email not sent")
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    let alertController = UIAlertController(title: nil, message: "No email user found", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "Try Again", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: false){
                        
                    }
                }
            }
        }
    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let ViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
        
        self.presentViewController(ViewController, animated: true, completion: nil)           
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

