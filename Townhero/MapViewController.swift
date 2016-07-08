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
    
    var green = [CLLocationCoordinate2D]()
    var blue = [CLLocationCoordinate2D]()
    var yellow = [CLLocationCoordinate2D]()
    var red = [CLLocationCoordinate2D]()
    
    
    var didCall = 0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
        
        if annotation.isEqual(mapView.userLocation){
            //trychanging the user to green dot
            var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.tintColor = UIColor.greenColor()
            
            return pinView
        }
        
        
        if annotation.coordinate.latitude != mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude != mapView.userLocation.coordinate.longitude {
        
        var tempC = annotation.coordinate
        
        for each in red{
            var tempEach = each
            
            if tempEach.longitude == tempC.longitude && tempEach.latitude == tempC.latitude{
                var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
                pinView.tintColor = UIColor.greenColor()
                return pinView
                
            }
        }
        
        }
            
       return nil
        
      
}
    
    //
    //
    //        pin.canShowCallout = true
    //        pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
    //        pin.pinTintColor = UIColor.yellowColor()
    //        return pin
    //
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        mapView.setRegion(MKCoordinateRegionMake(view.annotation!.coordinate, MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        //
        
        
        //
        
    }
    
    func addMapNotation1(tempParking: Parking) -> Void{
        
        var point = MKPointAnnotation()
        
        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!
        
        self.green.append(point.coordinate)
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
        
    }//End of addMapNotation func
    
    func addMapNotation2(tempParking: Nature) -> Void{
        
        var point = MKPointAnnotation()
        
        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!
        
        self.green.append(point.coordinate)
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
        
    }//End of addMapNotation func
    
    func addMapNotation3(tempParking: Safety) -> Void{
        
        var point = MKPointAnnotation()
        
        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!
        
        self.red.append(point.coordinate)
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
        
    }//End of addMapNotation func
    
    
    func addMapNotation4(tempParking: Service) -> Void{
        
        var point = MKPointAnnotation()
        
        point.title = tempParking.title
        point.subtitle = tempParking.des
        
        
        point.coordinate.latitude = Double(tempParking.lat!)!
        point.coordinate.longitude = Double(tempParking.long!)!
        
        self.yellow.append(point.coordinate)
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
            
            var tempParking = Parking(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1])
            
            
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
            
            var tempParking = Nature(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1])
            
            
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
            
            var tempParking = Safety(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1])
            
            
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
            
            var tempParking = Service(tempTitle: tempString![0], tempDes: tempDes![0] , tempLat: tempCor![0] , tempLong: tempCor![1])
            
            
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
            dvc.lat = self.lat
            dvc.long = self.long
        }
        
    }
    
    
    
}//End of the VC Class


