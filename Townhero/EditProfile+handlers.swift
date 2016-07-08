//
//  EditProfile+handlers.swift
//  Townhero
//
//  Created by Pasha Bahadori on 7/7/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FBSDKCoreKit

extension EditProfileTableVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func TapFunc() {
        print("Profile Pic Tapped")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let photoOptionAlertController = UIAlertController(title: "Edit Profile Picture", message: nil, preferredStyle: .Alert)
        
        let cameraAction = UIAlertAction(title: "Take a Camera Shot", style: .Default, handler: { (UIAlertAction) in
            
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        })
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Photo Library", style: .Default, handler: { (UIAlertAction) in
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (UIAlertAction) in
            // ..
        }
        
        photoOptionAlertController.addAction(cameraAction)
        photoOptionAlertController.addAction(photoLibraryAction)
        photoOptionAlertController.addAction(cancelAction)
        
        self.presentViewController(photoOptionAlertController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = editingInfo!["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = editingInfo!["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            editProfilePicImageView.image = selectedImage
        }
        
        let verifyNameAlertController = UIAlertController(title: "Edit Photo", message: "Your Photo Has Been Updated!", preferredStyle: .Alert)
        let verifyNameAction = UIAlertAction(title: "Done", style: .Default, handler: { (UIAlertAction) in
            // ...
        })
        
        
        self.view.endEditing(true)
        
        // Uploads the 24MB picture to Firebase Storage
        handleRegister()
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        verifyNameAlertController.addAction(verifyNameAction)
        
        self.presentViewController(verifyNameAlertController, animated: true, completion: nil)
        
    }
    
    func handleRegister() {
        //successfully authenticated user
        let imageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.editProfilePicImageView.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
            })
        }
        
    }
}

















