//
//  LoginViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 1/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var imageLoginBackground: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageTheLoginBackground: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("studylapse", ofType: "gif")!))
        self.imageLoginBackground.animatedImage = imageTheLoginBackground
        self.imageLoginBackground.contentMode = UIViewContentMode.ScaleAspectFill
        [self.view .addSubview(self.imageLoginBackground)]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        print("Inside viewdidload of LoginVC")
    }
    
    @IBAction func logInPressed(sender: AnyObject) {
        if self.userTextField.text != "" && self.passwordTextField.text != "" {
            let username = self.userTextField.text
            let password = self.passwordTextField.text
            
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            // Send a request to login
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {
                    let alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HouseholdsOverview")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    //self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
                    
                } else {
                    let alert = UIAlertController(title: "Invalid Login!", message: "Try again.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                }
            })
        } else {
            let alert = UIAlertController(title: "Invalid login credentials!", message: "Try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }
    
    @IBAction func passwordReset(sender: AnyObject) {
        if self.userTextField.text != ""{
            print("\nreset checker works")
            
            let email = self.userTextField.text
            let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            // Send a request to reset a password
            PFUser.requestPasswordResetForEmailInBackground(finalEmail)
            
            let alert = UIAlertController (title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalEmail + ".", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Username or Email required!", message: "Try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
