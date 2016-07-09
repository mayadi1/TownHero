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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
