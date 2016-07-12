//
//  Services.swift
//  Townhero
//
//  Created by Mohamed on 7/5/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//


import Foundation
import UIKit

class Service {
    
    
    var title: String?
    var des: String?
    var lat: String?
    var long: String?
    var photo: String?
    
    init(tempTitle: String, tempDes: String, tempLat: String, tempLong: String, tempPhoto: String){
        
        self.title = tempTitle
        self.des = tempDes
        self.lat = tempLat
        self.long = tempLong
        self.photo = tempPhoto
    }
    
    
    
}