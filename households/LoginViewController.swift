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
    
    //@IBOutlet var imageLights: FLAnimatedImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Inside viewdidload of LoginVC")
        let object = PFObject(className: "TestObject")
        object.setObject("John", forKey: "foo")
        object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                print("Object Uploaded")
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
        //let imageTheLights: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("lights", ofType: "gif")!))
        //self.imageLights.animatedImage = imageTheLights
        //[self.view .addSubview(self.imageLights)]
    }
    
    
    @IBAction func logInPressed(sender: AnyObject) {
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
                let alert = UIAlertView(title: "Invalid Login!", message: "\(error)", delegate: self, cancelButtonTitle: "I'm innocent!")
                alert.show()
            }
        })
    }
}
