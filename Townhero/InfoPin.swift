//
//  InfoPin.swift
//  Townhero
//
//  Created by Mohamed on 7/8/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseAuth
import Firebase



class InfoPin: UIViewController {
    
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser

    var nature: Nature?
    var parking: Parking?
    var safety: Safety?
    var services: Service?
    var kind: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var desTestField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
            if kind == "service"{
                self.titleTextField.text = services?.title
                self.desTestField.text = services?.des
        }
        
        if kind == "safety"{
            self.titleTextField.text = safety?.title
            self.desTestField.text = safety?.des
        }
        
        if kind == "parking"{
            self.titleTextField.text = parking?.title
            self.desTestField.text = parking?.des
        }
        
        if kind == "nature"{
            self.titleTextField.text = nature?.title
            self.desTestField.text = nature?.des
        }
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
    }
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false) {
            
        }
    }
}
