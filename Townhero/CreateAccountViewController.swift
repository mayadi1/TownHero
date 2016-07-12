//
//  CreateAccountViewController.swift
//  InstaClone
//
//  Created by Salar Kohnechi on 6/20/16.
//  Copyright © 2016 Salar Kohnechi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var verifyPassword: UITextField!
    
    
    var passNameField: String?
    var passAddressField: String?
    var passZipField: String?
    
    let usersRef = FIRDatabase.database().reference().child("Users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pushedTap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.selectPhoto(_:)))
        pushedTap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(pushedTap)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        
        
        // Used to dismiss keyboard
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view!.addGestureRecognizer(tap)
        
    }
    
    
    func selectPhoto(tap: UITapGestureRecognizer) {
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.imagePicker.sourceType = .Camera
            
        }else{
            self.imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
        
    }
    
    var fileUrl: String!
    
    
    
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        var data = NSData()
        let newImage = self.ResizeImage(self.profileImage.image!,targetSize: CGSizeMake(390, 390.0))
        data = UIImageJPEGRepresentation(newImage, 0.1)!
        
        if passwordField.text == verifyPassword.text {
            
            
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                
                
                if error == nil {
                    
                    let currentUserUID = FIRAuth.auth()?.currentUser?.uid
                    
                    if let userID = currentUserUID {
                        //                        self.usersRef.child(userID).child("profilepicture").setValue("https://firebasestorage.googleapis.com/v0/b/townhero-5732d.appspot.com/o/u7ECcv595vgoy64SEnxhOTawcOa2%2Femptyprofilepic.png?alt=media&token=a865bf9d-b8de-4e63-9049-a067de1a75b5")
                        self.usersRef.child(userID).child("name").setValue(self.passNameField!)
                        self.usersRef.child(userID).child("email").setValue(self.emailField.text)
                        self.usersRef.child(userID).child("address").setValue(self.passAddressField!)
                        self.usersRef.child(userID).child("zip").setValue(self.passZipField)
                        
                        
                        let rootRef = FIRDatabase.database().reference()
                        
                        let changeRequest = user?.profileChangeRequest()
                        //  changeRequest?.photoURL = NSURL(string: )
                        changeRequest?.displayName = self.passNameField!
                        //      changeRequest?.displayName = self.emailField.text
                        changeRequest?.commitChangesWithCompletion({ (error) in
                            if let error = error {
                                print(error.localizedDescription)
                                
                                return
                            }
                        })
                        
                        let filePath = "profileImage/\(user!.uid)"
                        let metadata =  FIRStorageMetadata()
                        metadata.contentType = "image/jpeg"
                        
                        self.storageRef.child(filePath).putData(data, metadata: metadata, completion: { (metadata, error) in
                            if let error = error{
                                print("\(error.description)")
                                return
                            }
                            self.fileUrl = metadata?.downloadURLs![0].absoluteString
                            rootRef.child("Users").child("\(user!.uid)").child("userProfilePic").setValue(self.fileUrl)
                            let changeRequestPhoto = user!.profileChangeRequest()
                            changeRequestPhoto.photoURL = NSURL(string: self.fileUrl)
                            changeRequestPhoto.commitChangesWithCompletion({ (error) in
                                if let error = error{
                                    print(error.localizedDescription)
                                    return
                                }else{
                                    print("Profile Updated")
                                    
                                }
                            })
                            
                        })
                        
                        let alertController = UIAlertController(title: "Welcome", message: "Sign up completed", preferredStyle: .Alert)
                        
                        
                        let OKAction = UIAlertAction(title: "Login", style: .Default) { (action:UIAlertAction!) in
                            
                            let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
                            
                            
                            let MapViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView")
                            
                            self.presentViewController(MapViewController, animated: false, completion: nil)
                        }
                        alertController.addAction(OKAction)
                        
                        self.presentViewController(alertController, animated: true, completion:nil)
                        
                        
                        
                        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
                        
                        
                        let mainViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView")
                        
                        self.presentViewController(mainViewController, animated: true, completion: nil)
                        
                    }
                }
                else {
                    print(error?.description)
                    print("User Not Created")
                    print(error?.code)
                    
                    let alertController = UIAlertController(title: nil, message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Login", style: .Cancel) { (action) in
                        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                        let ViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
                        
                        self.presentViewController(ViewController, animated: true, completion: nil)
                    }
                    alertController.addAction(cancelAction)
                    
                    let OKAction = UIAlertAction(title: "Try Again", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
            }
        } else {
            
            let alertController = UIAlertController(title: nil, message: "Passwords do not match", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Try Again", style: .Cancel){ (action) in
            }
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func dismissKeyboard() {
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage.image = selectedPhoto
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    @IBAction func alreadyHaveAccountPressed(sender: AnyObject) {
        self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
