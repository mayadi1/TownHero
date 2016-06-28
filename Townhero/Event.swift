//
//  Events.swift
//  Townhero
//
//  Created by Mohamed on 6/27/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

 class Events: NSObject {
    let  name: String
    let address: String
    let lat: Double
    let long: Double
    let des: String
    let date: Double
    
    
    
    public init(name: String,address: String, lat: Double, long: Double, des: String, date: Double){
        
        self.name = name
        self.address = address
        self.lat = lat
        self.long = long
        self.des = des
        self.date = date
        
        
    }
    
    
   public func info(){
        
        
        print("the event name is:")
        print(self.name)
        
    }
    
}
