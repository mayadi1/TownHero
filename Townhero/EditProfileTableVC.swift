//
//  EditProfileVC.swift
//  Townhero
//
//  Created by Pasha Bahadori on 6/27/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FBSDKCoreKit

class EditProfileTableVC: UITableViewController {
    @IBOutlet weak var editProfilePicImageView: UIImageView!
    @IBOutlet weak var editProfileEmail: UILabel!
    @IBOutlet weak var editProfileAddress: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfilePicImageView.layer.masksToBounds = false
        editProfilePicImageView.layer.cornerRadius = editProfilePicImageView.frame.height / 2
        editProfilePicImageView.clipsToBounds = true

   
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid
            
            self.editProfileEmail.text = email
            
            
            let data = NSData(contentsOfURL: photoUrl!)
//            self.userPic.image = UIImage(data: data!)
        
        
    }
    
    
    
    
    
    


    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     
     // CODE ON HOW TO INSTANTIATE SEGUE PROGRAMATICALLY IN STATIC CELLS
     /*
         override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
             if indexPath.section == 0 && indexPath.row == 1 {
                 print("Yankee doodle")
                 let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                 let editFullNameVC = storyboard.instantiateViewControllerWithIdentifier("EditFullNameViewController") as! EditFullNameVC
                 //            mvc.divvyStation = divvyStation
     
                 self.presentViewController(editFullNameVC, animated: true, completion: nil)
             }
             else if indexPath.section == 0 && indexPath.row == 2 {
                 print("Yankee doodle")
                 let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                 let editEmailVC = storyboard.instantiateViewControllerWithIdentifier("EditEmailViewController") as! EditEmailViewController
                 //            mvc.divvyStation = divvyStation
     
                 self.presentViewController(editEmailVC, animated: true, completion: nil)
             }
             else if indexPath.section == 0 && indexPath.row == 3 {
                 print("Yankee doodle")
                 let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                 let editLocationVC = storyboard.instantiateViewControllerWithIdentifier("EditLocationViewController") as! EditLocationVC
                 //            mvc.divvyStation = divvyStation
     
                 self.presentViewController(editLocationVC, animated: true, completion: nil)
             }
 */
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editEmailSegue"{
            let dvc = segue.destinationViewController as! EditEmailViewController
            dvc.passedEmail = self.editProfileEmail.text

            
        }
    }

}
