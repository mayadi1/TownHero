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
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(InfoPin.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        
        if kind == "service"{
            self.titleTextField.text = services?.title
            self.desTestField.text = services?.des
            self.photoURL = services?.photo
            
            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    var newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
            
        }
        
        if kind == "safety"{
            self.titleTextField.text = safety?.title
            self.desTestField.text = safety?.des
            self.photoURL = safety?.photo
            
            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    var newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
        }
        
        if kind == "parking"{
            self.titleTextField.text = parking?.title
            self.desTestField.text = parking?.des
            self.photoURL = parking?.photo
            
            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    var newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
            
        }
        
        if kind == "nature"{
            self.titleTextField.text = nature?.title
            self.desTestField.text = nature?.des
            self.photoURL = nature?.photo
            if self.photoURL != "No photo yet"{
                
                if let data = NSData(contentsOfURL: NSURL(string: self.photoURL!)!){
                    self.image = UIImage.init(data: data)
                    
                    var newImage = self.ResizeImage(self.image!,targetSize: CGSizeMake(540, 228.0))
                    self.imageView.image = newImage
                    
                }
            }
        }
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
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
    
    
    func selectPhoto(tap: UITapGestureRecognizer) {
        print("R")
        
        if self.image != nil {
            let storyboard = UIStoryboard(name: "InfoPin", bundle: nil)
            let pvc = storyboard.instantiateViewControllerWithIdentifier("imagePin") as! ImageViewController
            pvc.passedImage = self.image
            self.presentViewController(pvc, animated: true, completion: nil)
        }
        
        
    }
}//End of the class
