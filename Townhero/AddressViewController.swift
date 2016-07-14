//
//  AddressViewController.swift
//  Townhero
//
//  Created by Cindy Barnsdale on 7/3/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AddressViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    let usersRef = FIRDatabase.database().reference().child("Users")
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view!.addGestureRecognizer(tap)
        
    }
    
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        
        let user = FIRAuth.auth()?.currentUser
        
        usersRef.child("\(user!.uid)").child("address").setValue(self.addressField.text)
        usersRef.child("\(user!.uid)").child("email").setValue(user?.email)
        usersRef.child("\(user!.uid)").child("name").setValue(user?.displayName)
        usersRef.child("\(user!.uid)").child("zip").setValue(self.zipField.text)
        usersRef.child("\(user!.uid)").child("userProfilePic").setValue(user?.photoURL?.absoluteString)
        
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
        
        let MapViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView")
        
        self.presentViewController(MapViewController, animated: false, completion: nil)
        
        
    }
    
    
    
    
    
    
    //        let changeRequest = user?.profileChangeRequest()
    //
    //
    //        //changeRequest?.photoURL = self.profileImage.image
    //
    //        //changeRequest?.displayName = self.addressField.text
    //
    //        //changeRequest?.displayName = self.emailField.text
    //
    //
    //
    //        changeRequest?.commitChangesWithCompletion({ (error) in
    //            if let error = error {
    //                print(error.localizedDescription)
    //
    
    
    
    
    
    
    @IBAction func goBackButtonTapped(sender: AnyObject) {
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        try! FIRAuth.auth()!.signOut()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 5
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
}//End of the class


