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

class EditProfileTableVC: UITableViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var editProfilePicImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    var verifyPasswordTextField: UITextField?
    
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!

    
    var check = 0
    let user = FIRAuth.auth()?.currentUser
    let ref = FIRDatabase.database().reference()
    
    var passedTownHeroUser: TownHeroUser?
    var townHeroUser: TownHeroUser?
    
    let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        
        
        
        let pushedTap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.selectPhoto(_:)))
        pushedTap.numberOfTapsRequired = 1
        editProfilePicImageView.addGestureRecognizer(pushedTap)
        
        
        
        
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
                        self.view.endEditing(true)

                        // ...
                        // UPDATE NAME IN FB DATABASE
                        let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
                        self.ref.child("Users").child(userID).child("name").setValue(self.fullNameTextField.text)
                        self.fullNameTextField.placeholder = self.fullNameTextField.text
                    })
                    
                    verifyNameAlertController.addAction(verifyNameAction)
                    
                    self.view.endEditing(true)
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
                    self.view.endEditing(true)

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
                //TODO: Fix break with incorrect password
                FIRAuth.auth()?.signInWithEmail((self.user?.email)!, password: self.verifyPasswordTextField!.text!, completion: { (user, error) in
                    
                    if let error = error{
                        
                        // NEED TO HAVE VERIFICATION PASSWORD POP UP AGAIN AFTER EACH FAILED ATTEMPT
                        print(error.localizedDescription)
                        
                        
                
                        //TODO: change UIALerView to UIAlertViewController
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
    
    
    
    func selectPhoto(tap: UITapGestureRecognizer) {
        
      
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        
        let photoOptionAlertController = UIAlertController(title: "SourceType?", message: nil, preferredStyle: .Alert)
        
        let cameraAction = UIAlertAction(title: "Take a Camera Shot", style: .Default, handler: { (UIAlertAction) in
            
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
            
        })
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Photo Library", style: .Default, handler: { (UIAlertAction) in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (UIAlertAction) in
            // ..
        }
        
        photoOptionAlertController.addAction(cameraAction)
        photoOptionAlertController.addAction(photoLibraryAction)
        photoOptionAlertController.addAction(cancelAction)
        
        self.presentViewController(photoOptionAlertController, animated: true, completion: nil)    }
    
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
        
    }
    
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.editProfilePicImageView.image = selectedPhoto
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    //End of the editProfile Class
}
