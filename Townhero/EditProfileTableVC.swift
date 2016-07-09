//
//  EditProfileVC.swift
//  Townhero
//
//  Created by Pasha Bahadori on 6/27/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FBSDKCoreKit

class EditProfileTableVC: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var editProfilePicImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    var verifyPasswordTextField: UITextField?
    
    
    
    var check = 0
    let user = FIRAuth.auth()?.currentUser
    let ref = FIRDatabase.database().reference()
    
    var passedTownHeroUser: TownHeroUser?
    var townHeroUser: TownHeroUser?
    
    let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        
        
        
        
        editProfilePicImageView.userInteractionEnabled = true
        let aSelector: Selector = Selector("TapFunc")
        let profilePicTapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        profilePicTapGesture.numberOfTapsRequired = 1
        editProfilePicImageView.addGestureRecognizer(profilePicTapGesture)
        
        
        addressTextField.placeholder = TownHeroUser.sharedInstance.userAddress
        
        editProfilePicImageView.layer.masksToBounds = false
        editProfilePicImageView.layer.cornerRadius = editProfilePicImageView.frame.height / 2
        editProfilePicImageView.clipsToBounds = true
        
        
        emailTextField.placeholder = TownHeroUser.sharedInstance.email
        fullNameTextField.placeholder = TownHeroUser.sharedInstance.name
        editProfilePicImageView.image = TownHeroUser.sharedInstance.profilepicture
        addressTextField.placeholder = TownHeroUser.sharedInstance.userAddress
        
        
    }
    
    // This func is for editing the full name, email, and address
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let changeTextRequest = self.user!.profileChangeRequest()
        
        // IF NAMETEXTFIELD IS BEING EDITED ---------------------------------------------------------------------------------------------------
        
        if fullNameTextField.editing {
            fullNameTextField.autocorrectionType = .No
            changeTextRequest.displayName = fullNameTextField.text
            changeTextRequest.commitChangesWithCompletion({ (error) in
                // UPDATE NAME IN FB AUTH
                if let error = error{
                    print(error.localizedDescription)
                    self.resignFirstResponder()
                
                    return
                }
                else if self.fullNameTextField.text != "" {
                    print("\(self.user?.displayName)")
                    // UPDATE NAME HAS BEEN CHANGED
                    let verifyNameAlertController = UIAlertController(title: "Edit Name", message: "Name Has Been Updated!", preferredStyle: .Alert)
                    let verifyNameAction = UIAlertAction(title: "Done", style: .Default, handler: { (UIAlertAction) in
                        // ...
                        // UPDATE NAME IN FB DATABASE
                        let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
                        self.ref.child("Users").child(userID).child("name").setValue(self.fullNameTextField.text)
                        self.fullNameTextField.placeholder = self.fullNameTextField.text
                    })
                    
                    verifyNameAlertController.addAction(verifyNameAction)
                    
                    self.presentViewController(verifyNameAlertController, animated: true, completion: nil)
                    self.view.endEditing(true)
                }
            })
            
            return true
        }
        // IF EMAILTEXTFIELD IS BEING EDITED ------------------------------------------------------------------------------------------------
        
        if emailTextField.editing {
            
            FIRAuth.auth()?.signInWithEmail((user?.email)!, password: verifyPasswordTextField!.text!, completion: { (user, error) in
                if let error = error{
                    
                    print(error.localizedDescription)
                    
                    let passwordFailedAlertController = UIAlertController(title: nil, message: "\(error.localizedDescription)", preferredStyle: .Alert)
                    let passwordFailAction = UIAlertAction(title: "Done", style: .Cancel, handler: { (UIAlertAction) in
                        //..
                    })
                        
                        
                        passwordFailedAlertController.addAction(passwordFailAction)
                    
                    self.presentViewController(passwordFailedAlertController, animated: true, completion: nil)
   
                    
                }else{
                    
                    user?.updateEmail(self.emailTextField.text!, completion: { (error) in
                        if let error = error{
                            print(error.localizedDescription)
                            
                            self.view.endEditing(true)
                            
                            self.resignFirstResponder()
                            return
                            
                        }else{
                            print("Email Updated")
                            let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
                            self.ref.child("Users").child(userID).child("email").setValue(self.emailTextField.text)
                            self.emailTextField.placeholder = self.emailTextField.text
                            let updateEmailAlertController = UIAlertController(title: "Edit Email", message: "Email Has Been Successfully Updated!", preferredStyle: .Alert)
                            let updateEmailAction = UIAlertAction(title: "Done", style: .Default, handler: { (UIAlertAction) in
                                // ...
                            })
                            
                            updateEmailAlertController.addAction(updateEmailAction)
                            
                            self.presentViewController(updateEmailAlertController, animated: true, completion: nil)
                            
                            
                            self.view.endEditing(true)
                        }
                    })
                }
            })
            return true
        }
        
        
        if addressTextField.editing {
            
            self.check = 1
            if self.check == 1 {
                let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
                ref.child("Users").child(userID).child("address").setValue(self.addressTextField.text)
                self.check = 0
                self.addressTextField.placeholder = self.addressTextField.text
                addressTextField.endEditing(true)
                
                let verifyNameAlertController = UIAlertController(title: "Edit Address", message: "Address Has Been Updated!", preferredStyle: .Alert)
                let verifyNameAction = UIAlertAction(title: "Done", style: .Default, handler: { (UIAlertAction) in
                    // ...
                })
                
                verifyNameAlertController.addAction(verifyNameAction)
                
                self.presentViewController(verifyNameAlertController, animated: true, completion: nil)
                self.view.endEditing(true)
                
                return true
                
            }
            

            
           return true
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (emailTextField.editing && self.verifyPasswordTextField?.text == nil){
            emailTextField.autocorrectionType = .No
                let verifyEmailAlertController = UIAlertController(title: "Change Email", message: "Please Verify your Password", preferredStyle: .Alert)
            
                let verifyEmailAction = UIAlertAction(title: "Done", style: .Default, handler: { (UIAlertAction) in
                    
                    FIRAuth.auth()?.signInWithEmail((self.user?.email)!, password: self.verifyPasswordTextField!.text!, completion: { (user, error) in
                        
                        if let error = error{
                            
                            // NEED TO HAVE VERIFICATION PASSWORD POP UP AGAIN AFTER EACH FAILED ATTEMPT
                            print(error.localizedDescription)
                            
                            let passwordFailedAlertController = UIAlertView(title: nil, message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Done")
                            
                            
                            passwordFailedAlertController.show()
                            
                            
                           
                                }
                            })
                         })
            
            
            verifyEmailAlertController.addTextFieldWithConfigurationHandler({ (UITextField) in
                self.verifyPasswordTextField = UITextField
                self.verifyPasswordTextField!.placeholder = "Current Password"
                self.verifyPasswordTextField!.autocorrectionType = .No
                self.verifyPasswordTextField?.secureTextEntry = true
                
            })
            
            verifyEmailAlertController.addAction(verifyEmailAction)
            
            self.presentViewController(verifyEmailAlertController, animated: true, completion: nil)
        }
        
    }
    
    
    

    
    //End of the editProfile Class
}
