//
//  SearchTableViewController.swift
//  
//
//  Created by Cindy Barnsdale on 7/12/16.
//
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    let appleProducts = ["Mac", "iPhone", "Apple Watch", "iPad"]
    var filteredAppleProducts = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating a search bar
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        // Setting search bar to the top of the tableView.
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If search bar is active
        if self.resultSearchController.active {
        // Return filtered results array
            return self.filteredAppleProducts.count
        
        } else {
        // Otherwise show all results array.
            return self.appleProducts.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        // If search is active by user
        if self.resultSearchController.active {
        // show filtered results
            cell!.textLabel?.text = self.filteredAppleProducts[indexPath.row]
        } else {
        // show all possible results
            cell!.textLabel?.text = self.appleProducts[indexPath.row]
        }
        
        
        return cell!
    }
    
    // Updates search results when search bar in use by user
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // Removing all items in filteredAppleProducts array so we can add new search results
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        
        // Taking whatever results are in the search bar and searching for it in SELF
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        // SELF references this line of code since we inserted searchPredicate at the end
        // It finds results in the total results array and assigns it to a constant.
        let array = (self.appleProducts as NSArray).filteredArrayUsingPredicate(searchPredicate)
        // Casting the above array into an array of strings since filteredArrayUsingPredicate is an obj-c method. Put it back into the filtered results and reload the tableView.
        self.filteredAppleProducts = array as! [String]
        
        self.tableView.reloadData()
        
    }



} // end
