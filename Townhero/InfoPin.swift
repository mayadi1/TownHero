//
//  InfoPin.swift
//  Townhero
//
//  Created by Mohamed on 7/8/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseAuth
import Firebase



class InfoPin: UIViewController {
    
    
    
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    var nature: Nature?
    var parking: Parking?
    var safety: Safety?
    var services: Service?
    
    
    var passedLat: String?
    var passedLong: String?
    
    var kind: String?
    
    var image: UIImage?
    
    var photoURL: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var desTestField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pushedTap = UITapGestureRecognizer(target: self, action: #selector(InfoPin.selectPhoto(_:)))
        pushedTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(pushedTap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(PinDetailViewController.respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
        
        
        if kind == "service"{
            self.titleTextField.text = services?.title
            self.desTestField.text = services?.des
            self.photoURL = services?.photo
            self.passedLat = services?.lat
            self.passedLong = services?.long
            
            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    let newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
            
        }
        
        if kind == "safety"{
            self.titleTextField.text = safety?.title
            self.desTestField.text = safety?.des
            self.photoURL = safety?.photo
            self.passedLat = safety?.lat
            self.passedLong = safety?.long

            
            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    let newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
        }
        
        if kind == "parking"{
            self.titleTextField.text = parking?.title
            self.desTestField.text = parking?.des
            self.photoURL = parking?.photo
            self.passedLat = parking?.lat
            self.passedLong = parking?.long

            
            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    let newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
            
        }
        
        if kind == "nature"{
            self.titleTextField.text = nature?.title
            self.desTestField.text = nature?.des
            self.photoURL = nature?.photo
            self.passedLat = nature?.lat
            self.passedLong = nature?.long

            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    let newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
        }
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
        let textToShare = "Check out this report!"
        
       
        if self.image != nil{
    
            let activityVC = UIActivityViewController(activityItems: [self.image!, "\(textToShare)", self.titleTextField.text!, self.desTestField.text!], applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.presentViewController(activityVC, animated: true, completion: nil)
        }else{
            let objectsToShare = [textToShare, self.titleTextField.text, self.desTestField.text]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false) {
            
        }
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped Down")

            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                self.dismissViewControllerAnimated(true, completion: {
                    
                })
                
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    func selectPhoto(tap: UITapGestureRecognizer) {
        print("R")
        
        if self.image != nil {
            let storyboard = UIStoryboard(name: "InfoPin", bundle: nil)
            let pvc = storyboard.instantiateViewControllerWithIdentifier("imagePin") as! ImageViewController
            pvc.passedImage = self.image
            self.presentViewController(pvc, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func flagButtonPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Help Us Understand What's Happening", message: "What's going on?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            
            print(alertController.textFields?.first)
            print(alertController.textFields)
            
            
            if let text = alertController.textFields?.last?.text{
                let tempArray = [self.titleTextField.text, self.desTestField.text, text]
                self.rootRef.child("Flag").child((self.user?.uid)!).childByAutoId().setValue(tempArray)

            }
            
 
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.view.endEditing(false)
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Explain..."
        }
       
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction func directionsButtonPressed(sender: AnyObject) {
        
        
        self.openMapForPlace()

    }
    
    func openMapForPlace() {
        
        
        let lat1 : NSString = self.passedLat!
        let lng1 : NSString = self.passedLong!
        
        
        let latitute:CLLocationDegrees =  lat1.doubleValue
        let longitute:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.titleTextField.text
        mapItem.openInMapsWithLaunchOptions(options)
        
    }

}//End of the class
