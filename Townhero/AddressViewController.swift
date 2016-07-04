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

class AddressViewController: UIViewController{

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var addressField: UITextField!
    let user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        
        

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view!.addGestureRecognizer(tap)
    
    }

   
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
       

        let changeRequest = user?.profileChangeRequest()
        //       changeRequest?.photoURL = self.profileImage.image
        
        //changeRequest?.displayName = self.addressField.text
        

        
        //      changeRequest?.displayName = self.emailField.text
        changeRequest?.commitChangesWithCompletion({ (error) in
            if let error = error {
                print(error.localizedDescription)
                
                
                
                
                return
            }else{
                
                
                let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
                // Uncomment this when we get feed done and add HomeView as the storyboard id.
                
                let MapViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView")
                
                self.presentViewController(MapViewController, animated: false, completion: nil)

            }
            
            
        })
        
        
        
    
    
    }
 
    @IBAction func goBackButtonTapped(sender: AnyObject) {
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        
        let loginViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
        
        self.presentViewController(loginViewController, animated: true, completion: nil)

    }
    
    
  
}
