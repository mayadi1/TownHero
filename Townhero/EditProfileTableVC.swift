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
    
    let userID: String = (FIRAuth.auth()?.currentUser?.uid)!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        
   
        
        
        editProfilePicImageView.userInteractionEnabled = true
        let aSelector: Selector = "TapFunc"
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
                if let error = error{
                    print(error.localizedDescription)
                    self.resignFirstResponder()
                    return
                }
                else if self.fullNameTextField.text != "" {
                    print("\(self.user?.displayName)")
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
            }
        
            return true
        if addressTextField.editing {
            let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
            
            let key = ref.child("Users").child(userID).childByAutoId().key
//            let post = ["uid": "\(user.uid)",
//                        "caption": "\(self.captionTextField!.text!)",
//                        "location": "\(self.locationTextField!.text!)",
//                        "friends": "\(self.taggedFriendsTextField!.text!)",
//                        "imageFilename": "\(final)",
//                        "postDateTime":"\(now)",
//                        "postID":"\(key)"]
//            let childUpdates = ["/user/\(user.uid)/posts/\(key)": post,
//                                "/posts/\(key)/": post]
//            ref.updateChildValues(childUpdates)
            
            
            }
        }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
            if (emailTextField.editing && self.verifyPasswordTextField?.text == nil){
                emailTextField.autocorrectionType = .No
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
