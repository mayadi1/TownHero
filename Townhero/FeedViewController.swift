//
//  FeedViewController.swift
//  Townhero
//
//  Created by Cindy Barnsdale on 6/26/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
   let usersRef = FIRDatabase.database().reference()
        
        
        usersRef.child("Fef").setValue("efefef")
        // Do any additional setup after loading the view.
    }

   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return 20
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FeedTableViewCell
        return cell
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
