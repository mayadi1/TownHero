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

class ProfileTVC: UITableViewController {
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var townHeroUser: TownHeroUser?
    let ref = FIRDatabase.database().reference()
    
    // observe an event in Firebase. You can observe a single event or multiple event, everytime there is a change to users, then there is a method that gets called. Since Friebase is so quick everytime you come in to the viewAppears, you already make an API call and hit FireBase
    //
    
    // When user signs up through Facebook, their Facebook Name, E-mail, and Profile pic should be used to create a new user entry in Firebase and we then work with that user entry in Firebase now instead of directly with the Facebook Auth user
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.userPic.layer.cornerRadius = 19
        
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
           

            if let homeAddress: String? = user.accessibilityLabel {
                TownHeroUser.sharedInstance.userAddress = homeAddress
            }
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEditProfileSegue"{
            let dvc = segue.destinationViewController as! EditProfileTableVC
            //            dvc.passedTownHeroUser = townHeroUser!
            
        }
    }
    
    
    
    
    
    
}//End of the ProfileTVC class