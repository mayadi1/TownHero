//
//  EditFullNameVC.swift
//  Townhero
//
//  Created by Pasha Bahadori on 6/28/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class EditFullNameVC: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   let TEXT_FIELD_LIMIT = 15
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //An expression works with Swift 2
        return (textField.text?.characters.count ?? 0) + string.characters.count - range.length < TEXT_FIELD_LIMIT
        //For Swift 1.2
        //        return count((textField.text ?? "").utf16) + count(string.utf16) - range.length <= TEXT_FIELD_LIMIT
    }
    
    //...
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


