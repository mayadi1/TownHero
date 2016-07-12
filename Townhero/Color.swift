//
//  Color.swift
//  Townhero
//
//  Created by Mohamed on 7/8/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//
import UIKit
import MapKit

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}