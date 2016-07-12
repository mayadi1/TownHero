//
//  SearchViewController.swift
//  Townhero
//
//  Created by Salar Kohnechi on 7/11/16.
//  Copyright © 2016 Salar Kohnechi. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchArray = [SearchItem]()
    var filteredResults = [SearchItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchArray += [SearchItem(name: "Vea Software")]
        self.searchArray += [SearchItem(name: "Apple")]
        self.searchArray += [SearchItem(name: "iTunes")]
        self.searchArray += [SearchItem(name: "iPhone")]
        self.searchArray += [SearchItem(name: "iMac")]
        self.searchArray += [SearchItem(name: "iPad")]
    
        self.tableView.reloadData()
    }

        // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            return self.filteredResults.count
            
        } else {
            
            return self.searchArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var user : SearchItem
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            user = self.filteredResults[indexPath.row]
        } else {
            user = self.searchArray[indexPath.row]
        }
        
        cell.textLabel?.text = user.name
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var user : SearchItem
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
         user = self.filteredResults[indexPath.row]
        } else {
            user = self.searchArray[indexPath.row]
        }
        
        print(user.name)
    }
    
    
    // MARK: - Search

    func filterContentForSearchText(searchText: String, scope: String = "Title") {
        self.filteredResults = self.searchArray.filter({ ( user : SearchItem) -> Bool in
            
            var categoryMatch = (scope == "Title")
            var stringMatch = user.name.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil)
        })
    }
        
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!, scope: "Title")
        
        return true
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!, scope: "Title")
        
        return true
    }
    

    
}
