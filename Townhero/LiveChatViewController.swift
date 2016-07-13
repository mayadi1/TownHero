//
//  LiveChatViewController.swift
//  Townhero
//
//  Created by Mohamed Ayadi on 7/13/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class LiveChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("chatID", forIndexPath: indexPath)
        
        return cell
    }

    
    
}//End of the LivechatVC Class
