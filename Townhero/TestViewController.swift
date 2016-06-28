//
//  TestViewController.swift
//  Townhero
//
//  Created by Cindy Barnsdale on 6/28/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FBSDKCoreKit

class TestViewController: UIViewController {
    @IBOutlet weak var userPic: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userPic.layer.cornerRadius = self.userPic.frame.size.width/2
        
        self.userPic.clipsToBounds = true
        
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            if let photoUrl = user.photoURL{
                let data = NSData(contentsOfURL: photoUrl)
                
               
                    self.userPic.image = UIImage(data: data!)
                    
            }
//               let uid = user.uid;
            print(user.photoURL)
            
            self.nameLabel.text = name
            
            self.emailLabel.text = email
            
            //    self.addressLabel.text = uid
            
           
                
            
            }
            
            
            
      //  let storage = FIRStorage.storage()
   
            
            
            
         else {
            // No user is signed in.
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logOutButton(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        
        // Facebook log out by setting access token to nil, then sending back to the initial viewcontroller.
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        try! FIRAuth.auth()!.signOut()
        print("signed out")
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let ViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
        
        self.presentViewController(ViewController, animated: true, completion: nil)
        
    
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
