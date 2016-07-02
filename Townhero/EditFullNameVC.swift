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
    var passedFullName: String?
    var passedFullNameVCTownHeroUser: TownHeroUser?
    var currentUser: FIRUser?

    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.delegate = self
         self.fullNameTextField.placeholder = passedFullNameVCTownHeroUser?.name
        currentUser = FIRAuth.auth()?.currentUser

        // Do any additional setup after loading the view.
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 20
        let currentString: NSString = fullNameTextField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }

    @IBAction func onSaveButtonTapped (sender: UIBarButtonItem) {
        
        ref.child("users").child(currentUser!.uid).updateChildValues(["name": fullNameTextField.text!])
        
        TownHeroUser.sharedInstance.name = fullNameTextField.text
        
        // Need to somehow tell the user that their name change was succesfully changed
//        let saveAlert =
        
    }
    
    
}
    
// WORK IN PROGRESS: I need to set the limit on the amount of character that can be entered in a text field to 15 for firstNameTextField & lastNameTextField



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


