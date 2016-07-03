//
//  UserClass.swift
//  Townhero
//
//  Created by Pasha Bahadori on 7/1/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import Foundation
import UIKit

// A singleton is a design pattern that only lets the class have ONE instance object of that class
//
class TownHeroUser {
   
    var name: String!
    var email: String!
    var profilepicture: UIImage!
    var uid: String!
    var homeAddress: String!
    var workAddress: String!
    
    //Static allows only 1 instance of TownHeroUser to be available
    static let sharedInstance = TownHeroUser()
    
    private init() {
        
    }
    
//    init(name: String, email: String, photo: UIImage, uid: String) {
//        self.name = name
//        self.email = email
//        self.photo = photo
//        self.uid = uid
//        
//    }
    
}
// 