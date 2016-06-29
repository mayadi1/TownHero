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
                
                
                
                for item in self.file{
                    
                    let event = item as! NSDictionary
                    
                    
                    if let venue = event["venue"]{
                        
                        if let  tempAdd = venue.objectForKey("address_1"){
                            let addres = tempAdd as! String
                            
                            let title = event.objectForKey("name") as! String
                            let tempDate = event["time"]
                            if let des = event.objectForKey("description") {
                                
                                let lat = venue.objectForKey("lat") as! Double
                                 let lon = venue.objectForKey("lon") as! Double
                                
                                
                                self.event.append(Events(name: title, address: addres, lat: lat, long: lon, des: des as! String , date: (tempDate?.doubleValue)!))
                                
                            }
                        }
                    }
                }
            
            
                            
                    
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
            
            return self.event.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView .dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FeedTableViewCell
            
            
   
                        
                        let tempEvent = self.event[indexPath.row]
                        
                        
                        cell.config(tempEvent.address, title: tempEvent.name, date: tempEvent.date, des: tempEvent.des)
                        
                        
                    
            
            return cell
            
        }
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
            let dvc = segue.destinationViewController as! EventDetailViewController
            
            
            let index = tableView.indexPathForSelectedRow
            
            print("this is the indexPath.row \(index?.row)")
            
        dvc.passedEvent = self.event[(index?.row)!]
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
}
