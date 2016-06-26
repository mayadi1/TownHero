//
//  ViewController.swift
//  Townhero
//
//  Created by Mohamed on 6/26/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootRef = FIRDatabase.database().reference()
        
        rootRef.child("users").setValue("Fe") }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

