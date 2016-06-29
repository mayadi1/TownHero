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
    @IBOutlet weak var organizationImageView: UIImageView!
 
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
            userPic.layer.masksToBounds = false
            userPic.layer.cornerRadius = userPic.frame.height / 2
            userPic.clipsToBounds = true
        
            organizationImageView.layer.masksToBounds = false
            organizationImageView.layer.cornerRadius = organizationImageView.frame.height / 2
            organizationImageView.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid
            
            
            self.nameLabel.text = name
            
            
            //  Since we don't want the image to never return nil we comment this out last. Required if you don't want the code below.
            
            //            let data = NSData(contentsOfURL: photoUrl!)
            //            self.userPic.image = UIImage(data: data!)
            
            
            // Reference to the storage service
            let storage = FIRStorage.storage()
            // Reference your particular storage service/ Located at the top of storage menu in firebase.
            let storageRef = storage.referenceForURL("gs://townhero-5732d.appspot.com")
            
            // We moved this from below to here since download in memory requires the reference.
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
            // Since we don't want to keep redownloading and uploading the facebook profile image we have check our firebase storage to see if it exists already. So we download temporarily into phone memory before we check it.
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print("Unable to download image")
                } else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    
                    if(data != nil){
                        print("User image already exists, no need to download")
                        self.userPic.image = UIImage(data: data!)
                    }
                }
            }
            // This checks if the user doesn't have a profile image then move below and run our code for downloading.
            if(self.userPic.image == nil) {
                
                
                // Request to get the facebook users profile picture - convert to swift from obj-c. Located in facebook developer docs: User, Picture menu. We don't need connection, result, or error type - remove value. Remove first part and make profilePic. Remove user id next to graphPath: and add "me/picture. Add parameters with h,w, and redirect false since we want the picture to return a json. Replace request.startWithCompletionHandler with profilePic.start....
                var profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300,"width":300,"redirect":false], HTTPMethod: "GET")
                profilePic.startWithCompletionHandler({(connection, result, error) -> Void in
                    // Convert JSON into a dictionary so we can access it.
                    if (error == nil){
                        // By using print we can see the structure of the Json below.
                        print(result)
                        
                        let dictionary = result as? NSDictionary
                        // "data" was inserted since that's the top level in the JSON we printed.
                        let data = dictionary?.objectForKey("data")
                        let urlPic = (data?.objectForKey("url")) as! String
                        
                        // If an image is downloaded and we are receiving an image....
                        if let imageData = NSData(contentsOfURL: NSURL(string:urlPic)!)
                        {
                            // Refer to the folder we want to update into - Later moved up top out of this area
                            // let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                            
                            // Upload the image, refer to firebase storage docs: upload files menu.
                            let uploadTask = profilePicRef.putData(imageData, metadata:nil) {
                                metadata,error in
                                
                                if (error == nil) {
                                    // metadata can reference size, content, or downloadURL.
                                    let downloadUrl = metadata!.downloadURL
                                    
                                } else {
                                    print("error in downloading image")
                                    
                                    
                                }
                            }
                            // If the image exists and uploads correctly we'll update the image on storyboard.
                            
                            self.userPic.image = UIImage(data:imageData)
                            
                        }
                    }
                    
                })
            } //bracket to enclose our checking statement to download or not: if(self.userPic.image == nil)
            
        } else {
            // No user is signed in.
        }
        
        
    }
}

func roundImageView(imageView: UIImageView) {
    
//    imageView.layer.masksToBounds = false
//    imageView.layer.cornerRadius = userPic.frame.height / 2
//    imageView.clipsToBounds = true
//    
}









    

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 6
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


