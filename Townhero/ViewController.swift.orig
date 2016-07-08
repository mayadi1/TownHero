//
//  ViewController.swift
//  TownHero
//
//  Created by Mohamed on 6/30/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import AddressBookUI

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var addresslabel: UILabel!
    
    @IBOutlet weak var safetybutton: UIButton!
    
    @IBOutlet weak var vandPButton: UIButton!
    
    @IBOutlet weak var envirementButton: UIButton!
    
    @IBOutlet weak var servicesButton: UIButton!
    
    
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var mapView: MGLMapView!
    
    
    @IBOutlet weak var TitleTextField: UITextField!
    
    @IBOutlet weak var DescriptionTextField: UITextField!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 45.52258, longitude: -122.6732)
        point.title = "Voodoo Doughnut"
        point.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        
        mapView.addAnnotation(point)
        
        
        
        
        self.safetybutton.layer.cornerRadius = self.safetybutton.frame.size.height / 2
        self.vandPButton.layer.cornerRadius = self.vandPButton.frame.size.height / 2
        self.envirementButton.layer.cornerRadius = self.envirementButton.frame.height / 2
        self.servicesButton.layer.cornerRadius = self.servicesButton.frame.size.height / 2
        
        
        
        //Hide postButton, titleText, and DescText
        self.doneButtonOutlet.hidden = true
        self.TitleTextField.hidden = true
        self.DescriptionTextField.hidden = true
        
        
        
        self.safetybutton.hidden = true
        self.vandPButton.hidden = true
        self.envirementButton.hidden = true
        self.servicesButton.hidden = true
        //Done hiding
        
    
        
         //Zoom Map
//        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 41.89374, longitude: -87.6375187), zoomLevel: 17, animated: false)
        
        
        
        //Geocoding
        forwardGeocoding("\((self.addresslabel.text)!)")
        
        
        
        
        
    }
    
    
    
    //Hide Status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        
        
        
        if (sender.currentTitle == "Post"){
            self.postButton.setTitle("Cancel", forState: UIControlState.Normal)
            
            self.safetybutton.hidden = false
            self.vandPButton.hidden = false
            self.envirementButton.hidden = false
            self.servicesButton.hidden = false
            
        }else{
            
              self.postButton.setTitle("Post", forState: UIControlState.Normal)
            
            //Hide postButton, titleText, and DescText
            self.doneButtonOutlet.hidden = true
            self.TitleTextField.hidden = true
            self.DescriptionTextField.hidden = true
            
            
            
            self.safetybutton.hidden = true
            self.vandPButton.hidden = true
            self.envirementButton.hidden = true
            self.servicesButton.hidden = true
            //Done hiding
        }
        
        
        
    }
    
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        //Hide postButton, titleText, and DescText
        self.doneButtonOutlet.hidden = true
        self.TitleTextField.hidden = true
        self.DescriptionTextField.hidden = true
        
        self.safetybutton.hidden = true
        self.vandPButton.hidden = true
        self.envirementButton.hidden = true
        self.servicesButton.hidden = true
        
        self.view.endEditing(false)
        
        
    }
    
    
    
    @IBAction func catalogeButtonsPressed(sender: AnyObject) {
        
        
        self.doneButtonOutlet.hidden = false
        self.TitleTextField.hidden = false
        self.DescriptionTextField.hidden = false
        
    }
    
    
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                let point = MGLPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: (coordinate!.latitude),  longitude: (coordinate!.longitude))

                self.mapView.addAnnotation(point)
            
                
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
            }
        })
        
        
    }
   
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("pisa")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
            var image = UIImage(named: "pisavector")!
            
            // The anchor point of an annotation is currently always the center. To
            // shift the anchor point to the bottom of the annotation, the image
            // asset includes transparent bottom padding equal to the original image
            // height.
            //
            // To make this padding non-interactive, we create another image object
            // with a custom alignment rect that excludes the padding.
            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pisa")
        }
        
        return annotationImage
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped
        return true
    }

   
    
}//End of the VC Class


