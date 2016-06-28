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
    let usersRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    var names = []
    var meets = [NSDictionary]()
    var meetsArray = []
    var event = [Events]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        //Getting info from Meetup
        let url = NSURL(string: "https://api.meetup.com/2/open_events.json?zip=60654&text=volunteer&time=,1w&key=295a221f3120693541f4c725a227930")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            do {
                let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                let file = dictionary.valueForKey("results") as! NSArray
              
                
//                
//                ["utc_offset"]
//                
//                
//                
//                 self.event.append(Events(name: <#T##String#>, address: <#T##String#>, lat: <#T##Double#>, long: <#T##Double#>, des: <#T##String#>, date: <#T##Double#>)
//            
            
            } catch let error as NSError {
                print("Json ERROR: \(error.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                
            })
            
        }
        task.resume()
        
        
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FeedTableViewCell
        return cell
    }
    
    
    
    
    
}
