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

@objc protocol mapDelegate {
    //    optional func
    optional func safetySwitch()
    optional func parkingSwitch()
    optional func envirementSwitch()
    optional func serviceSwitch()
}






class ProfileTVC: UITableViewController {
    
    @IBOutlet weak var safetySwitch: UISwitch!
    @IBOutlet weak var parkingSwitch: UISwitch!
    @IBOutlet weak var envirementSwitch: UISwitch!
    @IBOutlet weak var serviceSwitch: UISwitch!
    
    
    @IBOutlet weak var showEditProfile: UITableViewCell!
    var delegate: SettingsDelegate?
    var mapdelegate: mapDelegate?

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
    
    
    override func viewWillAppear(animated: Bool) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        self.nameLabel.text = currentUser?.displayName

        //        var myValue:NSString = "1"
        //
        //        NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"Username")
        //
        //
//        
//        self.mapdelegate = parentViewController?.parentViewController?.presentingViewController
        
        
        let myOutput1: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("safetySwitch")
        let myOutput2: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("parkingSwitch")
        let myOutput3: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("envirementSwitch")
        let myOutput4: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("serviceSwitch")
        
        if let myOutput10 = myOutput1 {
            
            if  myOutput10 as! String == "1"{
                self.safetySwitch.setOn(false, animated: false)
            }else{
                self.safetySwitch.setOn(true, animated: false)
                
            }
        }
        
        
        if let myOutput20 = myOutput2 {
            
            if  myOutput20 as! String == "1"{
                self.parkingSwitch.setOn(false, animated: false)
            }else{
                self.parkingSwitch.setOn(true, animated: false)
                
            }
        }
        
        
        
        if let myOutput30 = myOutput3 {
            
            if  myOutput30 as! String == "1"{
                self.envirementSwitch.setOn(false, animated: false)
            }else{
                self.envirementSwitch.setOn(true, animated: false)
                
            }
        }
        
        
        
        if let myOutput40 = myOutput4 {
            
            if  myOutput40 as! String == "1"{
                self.serviceSwitch.setOn(false, animated: false)
            }else{
                self.serviceSwitch.setOn(true, animated: false)
                
            }
        }
        
        
        
    }
    
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
    
    @IBAction func safetySwitchPressed(sender: AnyObject) {
        if !safetySwitch.on && !self.parkingSwitch.on && !self.envirementSwitch.on && !self.serviceSwitch.on{
            print("no you can't turn all off, at least have one on plz")
            
            
            let alert = UIAlertController(title: "Alert", message: "All pins disabled.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel,  handler: { (UIAlertAction) in
                
                return
            })
            
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
            
        }
        
        
        let myOutput1: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("safetySwitch")
        
        if let myOutput10 = myOutput1 {
            
            if myOutput1 as! String == "1" && myOutput1 != nil {
                
                let myValue:NSString = "0"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"safetySwitch")
            }else{
                let myValue:NSString = "1"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"safetySwitch")
                
            }
        }else{
            
            let myValue:NSString = "1"
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"safetySwitch")
        }
        
        self.mapdelegate?.safetySwitch!()

    }
    
    
    @IBAction func parkingSwitchPressed(sender: AnyObject) {
        if !safetySwitch.on && !self.parkingSwitch.on && !self.envirementSwitch.on && !self.serviceSwitch.on{
            print("no you can't turn all off, at least have one on plz")
            
            
            let alert = UIAlertController(title: "Alert", message: "All pins disabled.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel,  handler: { (UIAlertAction) in
                
                return
            })
            
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
            
        }
        
        let myOutput1: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("parkingSwitch")
        
        if let myOutput10 = myOutput1 {
            if myOutput1 as! String == "1" && myOutput1 != nil {
                
                let myValue:NSString = "0"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"parkingSwitch")
            }else{
                let myValue:NSString = "1"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"parkingSwitch")
                
            }
        }else{
            let myValue:NSString = "1"
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"parkingSwitch")
        }
        self.mapdelegate?.parkingSwitch!()
    }
    
    
    @IBAction func envirementSwitchPressed(sender: AnyObject) {
        if !safetySwitch.on && !self.parkingSwitch.on && !self.envirementSwitch.on && !self.serviceSwitch.on{
            print("no you can't turn all off, at least have one on plz")
            
            
            let alert = UIAlertController(title: "Alert", message: "All pins disabled.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel,  handler: { (UIAlertAction) in
                
                return
            })
            
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
            
        }
        let myOutput1: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("envirementSwitch")
        
        if let myOutput10 = myOutput1 {
            if myOutput1 as! String == "1" && myOutput1 != nil {
                
                let myValue:NSString = "0"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"envirementSwitch")
            }else{
                let myValue:NSString = "1"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"envirementSwitch")
                
            }
        }else{
            let myValue:NSString = "1"
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"envirementSwitch")
            
        }
        
        
        
        self.mapdelegate?.envirementSwitch!()
    }
    
    @IBAction func serviceSwitchPressed(sender: AnyObject) {
        if !safetySwitch.on && !self.parkingSwitch.on && !self.envirementSwitch.on && !self.serviceSwitch.on{
            print("no you can't turn all off, at least have one on plz")
            
            
            let alert = UIAlertController(title: "Alert", message: "All pins disabled.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel,  handler: { (UIAlertAction) in
                
                return
            })
            
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
            
        }
        
        
        let myOutput1: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("serviceSwitch")
        
        if let myOutput10 = myOutput1 {
            if myOutput1 as! String == "1" && myOutput1 != nil {
                
                let myValue:NSString = "0"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"serviceSwitch")
            }else{
                let myValue:NSString = "1"
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"serviceSwitch")
                
            }
        }else{
            let myValue:NSString = "1"
            NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"serviceSwitch")
            
        }
        self.mapdelegate?.serviceSwitch!()
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.tabBarController?.selectedIndex = 1
            
            
        }
        
    }
    
    
    
}//End of the ProfileTVC class