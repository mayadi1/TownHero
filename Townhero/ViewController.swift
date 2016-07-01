//
//  ViewController.swift
//  TownHero
//
//  Created by Mohamed on 6/30/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Mapbox


class MapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    
    @IBOutlet weak var TitleTextField: UITextField!
    
    @IBOutlet weak var DescriptionTextField: UITextField!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide postButton, titleText, and DescText
        self.doneButtonOutlet.hidden = true
        self.TitleTextField.hidden = true
        self.DescriptionTextField.hidden = true
        
              let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 41.89374, longitude: -87.6375187)
        
        point.title = "Voodoo Doughnut"
        point.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        mapView.addAnnotation(point)
        
        
          mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 41.89374, longitude: -87.6375187), zoomLevel: 17, animated: false)
        
        
        //Zoom Map
        //    mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false
        

        
       
        
        
        
    }
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    
    
    //Hide Status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    @IBAction func postButtonPressed(sender: AnyObject) {
        
        self.doneButtonOutlet.hidden = false
        self.TitleTextField.hidden = false
        self.DescriptionTextField.hidden = false
    }
    
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        //Hide postButton, titleText, and DescText
        self.doneButtonOutlet.hidden = true
        self.TitleTextField.hidden = true
        self.DescriptionTextField.hidden = true
        
        self.view.endEditing(false)
        
        
    }
    

}//End of the VC Class


