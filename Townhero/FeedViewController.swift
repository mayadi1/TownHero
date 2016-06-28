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
    var file = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        //Getting info from Meetup
        let url = NSURL(string: "https://api.meetup.com/2/open_events.json?zip=60654&text=volunteer&time=,1w&key=295a221f3120693541f4c725a227930")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            do {
                let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                self.file = dictionary.valueForKey("results") as! NSArray
                
                
              
         
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
        
        return self.file.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FeedTableViewCell
      
        
        
        let event = self.file[indexPath.row] as! NSDictionary
        
        
        
       // let address = event["venue"]!!["address_1"]

       
        
      
        
        if let d = event["venue"]{
            
        if let address = d.objectForKey("address_1"){
          
            
            let title = event.objectForKey("name") as! String
            let date = event["time"]
            if let des = event.objectForKey("description") {
                cell.config(address as! String, title: title, date: (date?.doubleValue)!, des: des as! String)

            }
            
            
        }
        }
 
     
        return cell

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
      let dvc = segue.destinationViewController as! EventDetailViewController
        
        let index = tableView.indexPathForSelectedRow
        
        
        print(index)
       // dvc.selectedEvent = self.file[index!.row] as? NSDictionary
        
        
        
        
        
    }



    
    
}
