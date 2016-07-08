//
//  LoginViewController.swift
//  InstaClone
//
//  Created by Salar Kohnechi on 6/20/16.
//  Copyright © 2016 Salar Kohnechi All rights reserved.
//

import UIKit
import FBSDKLoginKit
// User FirebaseAuth to allow firebase to see users logging in.
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    let usersRef = FIRDatabase.database().reference().child("Users")
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    self.facebookLoginButton.hidden = true
        
        // Setting facebook button to clear background
        customizeButton(self.facebookLoginButton)
        
        
        // This code will check to see if the user is signed in or not. Located in firebase manage users: Step 1.
        
        
        backgroundColours = [UIColor.redColor(), UIColor.purpleColor()]
        backgroundLoop = 0
        self.animateBackgroundColour()
        
        
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user == nil{
                
            } else {
            
                // Taking the users child and analyzing if the user is logged in and if they have an address already in the system.
                let condition = self.usersRef.child("\(user!.uid)")
                
                condition.observeEventType(.Value, withBlock:  { (snapshot) in
                    
                    if user != nil && snapshot.exists() {
                        
                        
                        self.facebookLoginButton.hidden = true
                        //         If the user is signed in, show the map page.
                        
                 
                        
                       
//                            self.performSegueWithIdentifier("loginToMap", sender: self)
                        
                      
                        
                        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
                        
                        let MapViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView")
                        
                        self.presentViewController(MapViewController, animated: false, completion: nil)
                        
                        
                        
                    } else {
                        //                 If user is signed out, show the login button.
                        //                 This is the facebook login button.
                        
                        self.facebookLoginButton.hidden = false
                        
                        self.loginButton.center = self.view.center
                        self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                        self.facebookLoginButton.delegate = self
                        
                        //    self.view!.addSubview(self.loginButton)
                        
                        
                    }
                    
                })
            }
        }
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view!.addGestureRecognizer(tap)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            //        performSegueWithIdentifier("loginToFeed", sender: self)
        } else {
            print("Must Log In")
        }
    }
    
    // Customizing Facebook Login Button
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clearColor().CGColor
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        
        activitySpinner.startAnimating()
        
        self.facebookLoginButton.hidden = true
        //        if self.loginButton.hidden == true {
        //            } else {
        //            print("Facebook Not Logged In")
        //        }
        
        
        // Code to deal with users who hit cancel on the facebook login access.
        if (error != nil)
        {
            // If error occurs, login button appears
            self.facebookLoginButton.hidden = false
            activitySpinner.stopAnimating()
        }
        else if(result.isCancelled) {
            // handle the cancel event, show the login button
            self.facebookLoginButton.hidden = false
            activitySpinner.stopAnimating()
            
        } else {  // User hits OK to grant rights to use Facebook Login.
            print("user logged in")
            
            
            // Since Firebase cannot see users logged in even with facebook set up correctly, we have to add this code. Located in guides, auth, facebook, step 4.
            
            // This is getting an access token for the signed-in user and exchanging it for a Firebase credential:
            
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            
            // Step 5 authenticate with Firebase using the Firebase credential
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("user logged into firebase")
                
                // When user signed in with Facebook, send to address view controller.
                let user = FIRAuth.auth()?.currentUser
                
                let condition = self.usersRef.child("\(user!.uid)")
                
                
                condition.observeEventType(.Value, withBlock:  { (snapshot) in
                    
                    
                    if snapshot.exists() {
                        
                        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
                        // Uncomment this when we get feed done and add HomeView as the storyboard id.
                        
                        let MapViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView")
                        
                        self.presentViewController(MapViewController, animated: false, completion: nil)
                        
                        
                        
                    } else {
                        
                        let addressStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                        let ViewController: UIViewController = addressStoryBoard.instantiateViewControllerWithIdentifier("AddressView")
                        
                        self.presentViewController(ViewController, animated: false, completion: nil)
                    }
                    
                    
                })
                
                
                
                
                
            }
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        FIRAuth.auth()?.signInWithEmail(userNameField.text!, password: passwordField.text!) { (user, error) in
            
            if error == nil {
                print("User Logged In")
                
                self.performSegueWithIdentifier("loginToMap", sender: self)
                
                let myValue:NSString = self.userNameField.text!
                
                NSUserDefaults.standardUserDefaults().setObject(myValue, forKey:"Username")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            else {
                print("Invalid Login")
                print(error?.code)
                
                let alertController = UIAlertController(title: nil, message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Try Again", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                //
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
            
        }
    }
    
    
    func animateBackgroundColour () {
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop += 1
        } else {
            backgroundLoop = 0
        }
        UIView.animateWithDuration(15, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.view.backgroundColor =  self.backgroundColours[self.backgroundLoop];
        }) {(Bool) -> Void in
            self.animateBackgroundColour();
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}

