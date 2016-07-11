//
//  ViewController.swift
//  TownHero
//
//  Created by Mohamed on 6/30/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import MapKit
import FirebaseStorage
import FirebaseAuth
import Firebase


class MapViewController: UIViewController, MKMapViewDelegate{
    
    var lat = 0.0
    var long = 0.0
    
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var addresslabel: UILabel!
    
    
    
    
    var buttoPressedName: String?
    
    
    
    var natures = [Nature]()
    var parkings = [Parking]()
    var safetys = [Safety]()
    var services = [Service]()
    
    
    var zipCode: String?
    
    
    var didCall = 0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.addAnnotationFromGes(_:)))
        uilgr.minimumPressDuration = 0.3
        
        self.mapView.addGestureRecognizer(uilgr)
        
        self.mapView.delegate = self
        
        //Zoom
        
        
        
        
        
        
        
    }
    
    //Hide Status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        self.mapView.setRegion(MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.005, 0.005)), animated: true)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                if let Zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                    self.addresslabel.text = (city as String) + ", " + (placeMark.addressDictionary!["ZIP"] as? String)!
                    self.zipCode = Zip as String
                    self.didCall = self.didCall + 1
                    if self.didCall == 1 {
                        self.retrievePosts()}
                }
            }
            
        })
        
    }
    
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            let colorPointAnnotation = annotation as! ColorPointAnnotation
            pinView?.pinTintColor = colorPointAnnotation.pinColor
            pinView!.rightCalloutAccessoryView = UIButton(type: .InfoDark)
            
            pinView?.canShowCallout = true
            
            
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    //
    //
    //        pin.canShowCallout = true
    //        pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
    //        pin.pinTintColor = UIColor.yellowColor()
    //        return pin
    //
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //change this to Coordinates for better search

        
        for item in natures{
            
            if item.des == (view.annotation?.subtitle)! && item.title == (view.annotation?.title)!
            {
                let storyboard = UIStoryboard(name: "InfoPin", bundle: nil)
                let pvc = storyboard.instantiateViewControllerWithIdentifier("InfoPin") as! InfoPin
                pvc.nature = item
                pvc.kind = "nature"
                self.presentViewController(pvc, animated: true, completion: nil)
                
            }
            
        }
        
        
        for item in parkings{
            
            if item.des == (view.annotation?.subtitle)! && item.title == (view.annotation?.title)!
            {
                let storyboard = UIStoryboard(name: "InfoPin", bundle: nil)
                let pvc = storyboard.instantiateViewControllerWithIdentifier("InfoPin") as! InfoPin
                pvc.parking = item
                pvc.kind = "parking"
                self.presentViewController(pvc, animated: true, completion: nil)
                
            }
            
        }
        
        for item in safetys{
            
            if item.des == (view.annotation?.subtitle)! && item.title == (view.annotation?.title)!
            {
                let storyboard = UIStoryboard(name: "InfoPin", bundle: nil)
                let pvc = storyboard.instantiateViewControllerWithIdentifier("InfoPin") as! InfoPin
                pvc.safety = item
                pvc.kind = "safety"
                self.presentViewController(pvc, animated: true, completion: nil)
                
            }
            
        }
        
        for item in services{
            
            if item.des == (view.annotation?.subtitle)! && item.title == (view.annotation?.title)!
            {
                let storyboard = UIStoryboard(name: "InfoPin", bundle: nil)
                let pvc = storyboard.instantiateViewControllerWithIdentifier("InfoPin") as! InfoPin
                pvc.services = item
                pvc.kind = "service"
                self.presentViewController(pvc, animated: true, completion: nil)
                
            }
            
        }
        

    }
    
    func addMapNotation1(tempParking: Parking) -> Void{
        
        
        let point = ColorPointAnnotation(pinColor: UIColor.blueColor())
        
     
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!
        
        
        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
        
    }//End of addMapNotation func
    
    func addMapNotation2(tempParking: Nature) -> Void{
        
         let point = ColorPointAnnotation(pinColor: UIColor.greenColor())
        
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!

        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
        
    }//End of addMapNotation func
    
    func addMapNotation3(tempParking: Safety) -> Void{
        
          let point = ColorPointAnnotation(pinColor: UIColor.redColor())
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!
        
        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
        
    }//End of addMapNotation func
    
    
    func addMapNotation4(tempParking: Service) -> Void{
        
         let point = ColorPointAnnotation(pinColor: UIColor.yellowColor())
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!
        
        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
        
    }//End of addMapNotation func
    
  
    
    
    //Load Posts
    func retrievePosts() -> Void {
        
        let condition1 = rootRef.child("Post").child(self.zipCode!).child("UIDeviceRGBColorSpace 0 0 1 1")
        condition1.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            let tempDic: [String: [String]] = snapshot.value as! Dictionary
            
            
            
            
            var tempArray = tempDic["cordinates"]
            
     
            
            var tempString = tempDic["title"]
            var tempDes = tempDic["description"]
            var tempCor = tempDic["cordinates"]
            var tempPhoto = tempDic["photoURL"]
            
            var tempParking = Parking(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1], tempPhoto: tempPhoto![0])
            
            
            self.parkings.append(tempParking)
            
            
            self.addMapNotation1(tempParking)
        })
        
        
        let condition2 = rootRef.child("Post").child(self.zipCode!).child("UIDeviceRGBColorSpace 0 1 0 1")
        condition2.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            let tempDic: [String: [String]] = snapshot.value as! Dictionary
            
            
            
            
            var tempArray = tempDic["cordinates"]
            
            var tempString = tempDic["title"]
            var tempDes = tempDic["description"]
            var tempCor = tempDic["cordinates"]
            var tempPhoto = tempDic["photoURL"]

            
            var tempParking = Nature(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1], tempPhoto: tempPhoto![0])

            
            
            self.natures.append(tempParking)
            
            
            self.addMapNotation2(tempParking)
        })
        
        let condition3 = rootRef.child("Post").child(self.zipCode!).child("UIDeviceRGBColorSpace 1 0 0 1")
        condition3.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            let tempDic: [String: [String]] = snapshot.value as! Dictionary
            
            
            
            
            var tempArray = tempDic["cordinates"]

            var tempString = tempDic["title"]
            var tempDes = tempDic["description"]
            var tempCor = tempDic["cordinates"]
            var tempPhoto = tempDic["photoURL"]

            
            var tempParking = Safety(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1], tempPhoto: tempPhoto![0])

            
            
            self.safetys.append(tempParking)
            
            
            self.addMapNotation3(tempParking)
        })
        
        
        
        let condition4 = rootRef.child("Post").child(self.zipCode!).child("UIDeviceRGBColorSpace 1 1 0 1")
        condition4.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            let tempDic: [String: [String]] = snapshot.value as! Dictionary
            
            
            var tempArray = tempDic["cordinates"]
            var tempString = tempDic["title"]
            var tempDes = tempDic["description"]
            var tempCor = tempDic["cordinates"]
            var tempPhoto = tempDic["photoURL"]

            var tempParking = Service(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1], tempPhoto: tempPhoto![0])

            
            
            self.services.append(tempParking)
            
            
            self.addMapNotation4(tempParking)
        })
        
    }//End of the retrievePosts func
    
    
    
    func addAnnotationFromGes(gestureRecognizer:UIGestureRecognizer){
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinates = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            //
            
            self.lat = newCoordinates.latitude
            self.long = newCoordinates.longitude
            //            tempPoint?.coordinate.latitude = newCoordinates.latitude
            //            tempPoint?.coordinate.longitude = newCoordinates.longitude
            //
            
            
            //  dvc.point?.coordinate = newCoordinates
            
            performSegueWithIdentifier("showView", sender: nil)
            
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showView"{
            let dvc = segue.destinationViewController as! PinDetailViewController
            
    //Sometimes there is a dely when getting lat and Long so if self.lat is nil or lon is nil call get the info again
            dvc.lat = self.lat
            dvc.long = self.long
        }
        
    }
    


    
}//End of the VC Class


