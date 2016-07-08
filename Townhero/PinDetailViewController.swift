//
//  PinDetailViewController.swift
//  Townhero
//
//  Created by Mohamed on 7/7/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import MapKit
import FirebaseStorage
import FirebaseAuth
import Firebase


class PinDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser

    var lat = 0.0
    var long = 0.0
    var zipCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.descriptionTextField.text = "Description goes here.."
        self.descriptionTextField.textColor = UIColor.lightGrayColor()
        
       
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(PinDetailViewController.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        
        
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.lat, longitude: self.long)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
                self.zipCode = zip as String
            }
            
//            // Country
//            if let country = placeMark.addressDictionary!["Country"] as? NSString {
//                print(country)
//            }
            
        })
    }



    @IBAction func doneButtonPressed(sender: AnyObject) {
        
       
      //[String: [String]]
        
        let tempDic: Dictionary<String, Array<String>>  = ["title": ["\(self.titleTextField.text!)"], "description": ["\(self.descriptionTextField.text)"], "cordinates": ["\(self.lat)", "\(self.long)"], "photoURL": ["No photo yet"]]

        
        
        
    
        self.rootRef.child("Post").child(self.zipCode!).child("\(self.view.backgroundColor!)").childByAutoId().setValue(tempDic)
        
        
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }


    //Hide Status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            self.descriptionTextField.resignFirstResponder()
            return false}
    
        
        return true;
    }
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
        
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    
    
    
    @IBAction func changeBackgroundcolor(sender: AnyObject) {
        
        if sender.currentTitle == "Safety"{
            self.view.backgroundColor = UIColor.redColor()
        }
        
        if sender.currentTitle == "Service"{
            self.view.backgroundColor = UIColor.yellowColor()
        }
        if sender.currentTitle == "Parking"{
            self.view.backgroundColor = UIColor.blueColor()
        }
        if sender.currentTitle == "Envirement"{
            self.view.backgroundColor = UIColor.greenColor()
        }
    }
 

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                self.dismissViewControllerAnimated(true, completion: {
                
                })
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    
}//End of PinDetailViewController class

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    
}//End of the extension
