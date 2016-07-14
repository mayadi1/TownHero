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


class PinDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var selectedPhoto: UIImage!
    var fileUrl: String!
    
    let rootRef = FIRDatabase.database().reference()
    
    let user = FIRAuth.auth()?.currentUser
    let imagePicker = UIImagePickerController()
    
    var lat = 0.0
    var long = 0.0
    var zipCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //raise the view when view.edit is true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        //
        
        
   
        let pushedTap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.selectPhoto(_:)))
        pushedTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(pushedTap)
        
        self.descriptionTextField.text = "Description goes here.."
        self.descriptionTextField.textColor = UIColor.lightGrayColor()
        
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(PinDetailViewController.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(PinDetailViewController.respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
        self.geocode()
        
     
    }
    
    
    func geocode(){
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
        
        if self.zipCode == nil{
            self.geocode()
            
        }else{
  
        
        if self.titleTextField.text == "" || self.descriptionTextField.text == "" && (self.view.backgroundColor != UIColor.redColor() || self.view.backgroundColor != UIColor.greenColor() || self.view.backgroundColor != UIColor.blueColor() || self.view.backgroundColor != UIColor.yellowColor()){
            
            let alert = UIAlertController(title: "Alert", message: "You can't report if Title, Description and choice of catalog empty ", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Cancel,  handler: { (UIAlertAction) in
                self.addImageView.hidden = false
                return
            })
            
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
        }else{
            
            //[String: [String]]
            if self.imageView.image != nil{
                var data = NSData()
                let newImage = self.ResizeImage(self.imageView.image!,targetSize: CGSizeMake(390, 390.0))
                data = UIImageJPEGRepresentation(newImage, 0.1)!
                
                let currentDate = NSDate()
                
                
                print("tjhis si the time")
                print(currentDate.toLongTimeString())
                
                let filePath = "postImage/\(user!.uid)/\(currentDate.toLongTimeString())"
                let metadata =  FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                
                self.storageRef.child(filePath).putData(data, metadata: metadata, completion: { (metadata, error) in
                    if let error = error{
                        print("\(error.description)")
                        return
                    }
                    self.fileUrl = metadata?.downloadURLs![0].absoluteString
                    
                    let tempDic: Dictionary<String, Array<String>>  = ["title": ["\(self.titleTextField.text!)"], "description": ["\(self.descriptionTextField.text)"], "cordinates": ["\(self.lat)", "\(self.long)"], "photoURL": ["\(self.fileUrl)"]]
                    
                    self.rootRef.child("Post").child(self.zipCode!).child("\(self.view.backgroundColor!)").childByAutoId().setValue(tempDic)
                    
                })
                
                
                
            }else{
                //there is no image UIaler request an iamge if needed
                let tempDic: Dictionary<String, Array<String>>  = ["title": ["\(self.titleTextField.text!)"], "description": ["\(self.descriptionTextField.text)"], "cordinates": ["\(self.lat)", "\(self.long)"], "photoURL": ["No photo yet"]]
                
                self.rootRef.child("Post").child(self.zipCode!).child("\(self.view.backgroundColor!)").childByAutoId().setValue(tempDic)
                
            }
            self.dismissViewControllerAnimated(true) {
                
            }
        }
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
        if sender.currentTitle == "Environment"{
            self.view.backgroundColor = UIColor.greenColor()
        }
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
             self.dismissKeyboard()
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

      
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        
        let photoOptionAlertController = UIAlertController(title: "SourceType?", message: nil, preferredStyle: .Alert)
        
        let cameraAction = UIAlertAction(title: "Take a Camera Shot", style: .Default, handler: { (UIAlertAction) in

            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
            
        })

        let photoLibraryAction = UIAlertAction(title: "Choose from Photo Library", style: .Default, handler: { (UIAlertAction) in

            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (UIAlertAction) in
            self.addImageView.hidden = false
            
            // ..
        }
        
        photoOptionAlertController.addAction(cameraAction)
        photoOptionAlertController.addAction(photoLibraryAction)
        photoOptionAlertController.addAction(cancelAction)
        
        self.presentViewController(photoOptionAlertController, animated: true, completion: nil)    }
    
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.addImageView.hidden = true
        self.imageView.image = selectedPhoto
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.addImageView.hidden = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goBackButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    
    
    //view raise functions
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
    //end of the view raise functions
    
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

//Swift makes it really easy to create and use extensions. I create a sharedCode.swift file and put enums, extensions, and other fun stuff in it. I created a NSDate extension to add some typical functionality which is laborious and ugly to type over and over again:

extension NSDate
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toLongTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .FullStyle
        let timeString = formatter.stringFromDate(self)
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Day, fromDate: self)
        let day = components.day
        
        
        //Return Long Time String
        
        return "\(day)" + ", " + timeString
    }
    
    
    
    
}
