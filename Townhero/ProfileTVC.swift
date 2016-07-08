//
//  ProfileVC.swift
//  Townhero
//
//  Created by Pasha Bahadori on 6/27/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FBSDKCoreKit
import SideMenu
import FirebaseDatabase

protocol SettingsDelegate {
    func settingsDidDismiss()
}

class ProfileTVC: UITableViewController {
    
    var delegate: SettingsDelegate?
    let menuLeftNavigationController = UISideMenuNavigationController()
    // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration of it here like setting its viewControllers.
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var townHeroUser: TownHeroUser?
    let ref = FIRDatabase.database().reference()
    let userRef = FIRDatabase.database().reference().child("Users")
    
    
    
    // observe an event in Firebase. You can observe a single event or multiple event, everytime there is a change to users, then there is a method that gets called. Since Friebase is so quick everytime you come in to the viewAppears, you already make an API call and hit FireBase
    //
    
    // When user signs up through Facebook, their Facebook Name, E-mail, and Profile pic should be used to create a new user entry in Firebase and we then work with that user entry in Firebase now instead of directly with the Facebook Auth user
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPic.layer.masksToBounds = false
        userPic.layer.cornerRadius = userPic.frame.height / 2
        userPic.clipsToBounds = true
        
        // Use a Singleton for the current user that's logged in so I don't have to constantly keep retrieving user information from Firebase
        if let user = FIRAuth.auth()?.currentUser {
            TownHeroUser.sharedInstance.email = user.email
            TownHeroUser.sharedInstance.name = user.displayName
            TownHeroUser.sharedInstance.uid = user.uid
            
            
            if user.photoURL != nil {
                if let data = NSData(contentsOfURL: user.photoURL!){
                    self.userPic!.image = UIImage.init(data: data)
                }
            }
            TownHeroUser.sharedInstance.profilepicture = self.userPic.image
            
            self.nameLabel.text = TownHeroUser.sharedInstance.name
            self.userPic.image = TownHeroUser.sharedInstance.profilepicture
            
            //       TownHeroUser.sharedInstance.userAddress = // Firebase Address current User
        }
        
        // PULLING ADDRESS FROM FIRDATABASE
//        let refHandle = ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            let dataDict = snapshot.value as! [String: AnyObject]
//        })
//        
        let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
        ref.child("Users").child(userID).observeEventType(.Value, withBlock: { (snapshot) in
            let dataDict = snapshot.value as! [String: AnyObject]
            

            let address = dataDict["address"] as! String
            print(address)
          
            TownHeroUser.sharedInstance.userAddress = address
//            print(TownHeroUser.sharedInstance.userAddress)
        })
    }
    
 
    
    @IBAction func logoutButton(sender: UIButton) {
        
        try! FIRAuth.auth()!.signOut()
        
        // Facebook log out by setting access token to nil, then sending back to the initial viewcontroller.
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        try! FIRAuth.auth()!.signOut()
        print("signed out")
        
        
        self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        
//        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//        let ViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
//        self.presentViewController(ViewController, animated: true, completion: nil)
        
        
        
//        try! FIRAuth.auth()!.signOut()
//        
//        // Facebook log out by setting access token to nil, then sending back to the initial viewcontroller.
//        
//        FBSDKAccessToken.setCurrentAccessToken(nil)
//        
//        
//                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//                let ViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
//        
        //        self.parentViewController!.parentViewController!.presentingViewController!.presentViewController(ViewController, animated: true) {
        //                   self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        //        }
        
        //        self.navigationController?.dismissViewControllerAnimated(true, completion: {
        //            self.parentViewController!.parentViewController!.presentingViewController!.presentViewController(ViewController, animated: true, completion: nil)
        
//        self.dismissViewControllerAnimated(true) {
//            self.delegate?.settingsDidDismiss()
//            
//        }
    }
}//End of the ProfileTVC class