//
//  EditFullNameVC.swift
//  Townhero
//
//  Created by Pasha Bahadori on 6/28/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditFullNameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullNameTextField: UITextField!
    let ref = FIRDatabase.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.delegate = self
        
        // Here I set the placeholder text to the name I pulled from the FaceBookAuth in ProfileTVC
        fullNameTextField.placeholder = TownHeroUser.sharedInstance.name
        
        
//         self.fullNameTextField.placeholder = passedFullNameVCTownHeroUser?.name
//        currentUser = FIRAuth.auth()?.currentUser

      
        
        // NOT SURE IF I NEED BELOW CODE
//        var refHandle = self.ref.child("users").child(user.uid).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            
//            let userName = snapshot.value as! NSDictionary
//            print(userName)
////            let userDetails = userName.objectForKey(self.)
//            
//        })
        
    }

    
    // ---------------------------------------- TEXTFIELD FUNC TO LIMIT CHARACTERS USER CAN INPUT -----------------------------
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 20
        let currentString: NSString = fullNameTextField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }

    
  // ---------------------------------------- SAVING TEXT IN TEXTFIELD TO FBASE -----------------------------
        @IBAction func onSaveButtonTapped (sender: UIBarButtonItem) {
        
//        ref.child("users").child(currentUser!.uid).updateChildValues(["name": fullNameTextField.text!])

        TownHeroUser.sharedInstance.name = fullNameTextField.text
            
         ref.child("users").child(TownHeroUser.sharedInstance.uid).updateChildValues(["name": fullNameTextField.text!])
        
//         ref.child("users").child("\(TownHeroUser.sharedInstance.uid)/name").setValue(item)
        
        
        let alertController = UIAlertController(title: "Edit Name", message: "Your name has been updated successfully.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
            // ....
        }
        
          alertController.addAction(OKAction)
          self.presentViewController(alertController, animated: true) {
            
        }
        
//        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//        let pvc = storyboard.instantiateViewControllerWithIdentifier("EditProfileID") as! EditProfileTableVC
//        pvc.editProfileFullName.text = TownHeroUser.sharedInstance.name
//        
//        self.presentViewController(pvc, animated: true, completion: nil)

        
    }
}
    
// WORK IN PROGRESS:



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


