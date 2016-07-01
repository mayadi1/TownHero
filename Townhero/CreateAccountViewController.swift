//
//  CreateAccountViewController.swift
//  InstaClone
//
//  Created by Cindy Barnsdale on 6/20/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    let usersRef = FIRDatabase.database().reference().child("users")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view!.addGestureRecognizer(tap)
        
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
            
            if error == nil {
                print("User Created")
                
                let currentUserUID = FIRAuth.auth()?.currentUser?.uid
                
                
                if let userID = currentUserUID {
                        self.usersRef.child(userID).child("profilepicture").setValue("https://firebasestorage.googleapis.com/v0/b/townhero-5732d.appspot.com/o/u7ECcv595vgoy64SEnxhOTawcOa2%2Femptyprofilepic.png?alt=media&token=a865bf9d-b8de-4e63-9049-a067de1a75b5")
                        self.usersRef.child(userID).child("name").setValue(self.nameField.text)
                            self.usersRef.child(userID).child("email").setValue(self.emailField.text)
                            self.usersRef.child(userID).child("address").setValue(self.addressField.text)
                    
                }
                
                let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)

                
                let mainViewController: UITabBarController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView") as! UITabBarController
                
                self.presentViewController(mainViewController, animated: true, completion: nil)            }
                
            else {
                print(error?.description)
                print("User Not Created")
                
                let alertController = UIAlertController(title: nil, message: "User already exists", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Try Again", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                let destroyAction = UIAlertAction(title: "Use Facebook", style: .Default) { (action) in
                    print(action)
                }
                alertController.addAction(destroyAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
