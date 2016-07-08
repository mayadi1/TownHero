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

    let user = FIRAuth.auth()?.currentUser
    let ref = FIRDatabase.database().reference()
    
    var passedTownHeroUser: TownHeroUser?
    var townHeroUser: TownHeroUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        
        
        editProfilePicImageView.layer.masksToBounds = false
        editProfilePicImageView.layer.cornerRadius = editProfilePicImageView.frame.height / 2
        editProfilePicImageView.clipsToBounds = true
        
        
        emailTextField.placeholder = TownHeroUser.sharedInstance.email
        fullNameTextField.placeholder = TownHeroUser.sharedInstance.name
        editProfilePicImageView.image = TownHeroUser.sharedInstance.profilepicture
        
        
    }
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let changeTextRequest = self.user!.profileChangeRequest()
        
        
        // IF NAMETEXTFIELD IS BEING EDITED ---------------------------------------------------------------------------------------------------
        
        if fullNameTextField.editing {
            fullNameTextField.autocorrectionType = .No
            changeTextRequest.displayName = fullNameTextField.text
            changeTextRequest.commitChangesWithCompletion({ (error) in
                if let error = error{
                    print(error.localizedDescription)
                    self.resignFirstResponder()
                    return
                }
                else if self.fullNameTextField.text != "" {
                    print("Profile Updated")
                    let verifyNameAlertController = UIAlertController(title: "Edit Name", message: "Name Has Been Updated!", preferredStyle: .Alert)
                    let verifyNameAction = UIAlertAction(title: "Done", style: .Default, handler: { (UIAlertAction) in
                        // ...
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
                        
                        
                    }else{
                        
                        user?.updateEmail(self.emailTextField.text!, completion: { (error) in
                            if let error = error{
                                print(error.localizedDescription)
                                self.resignFirstResponder()
                                return
                            }else{
                                print("Email Updated")
                                self.view.endEditing(true)
                            }
                        })
                        ///
                    }
                })
            }
        
            return true
        }
        
        
        func textFieldDidBeginEditing(textField: UITextField) {
            if (emailTextField.editing && self.verifyPasswordTextField?.text == nil){
                let verifyEmailAlertController = UIAlertController(title: "Verify Current Password", message: nil, preferredStyle: .Alert)
                let verifyEmailAction = UIAlertAction(title: "Done", style: .Default, handler: { (UIAlertAction) in
                    //                if let emailVerify = verifyEmailTextField?.text {
                    //                    print(" Email = \(emailVerify)")
                    //                } else {
                    //                    print("No Username entered")
                    //                }
                    //                if let passwordVerify = verifyPasswordTextField.text {
                    //                    print("Password = \(passwordVerify)")
                    //                } else {
                    //                    print("No password entered")
                    //                }
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
