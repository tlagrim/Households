//
//  ResetPasswordViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 1/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    //@IBOutlet var imageLights: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let imageTheLights: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("lights", ofType: "gif")!))
        //self.imageLights.animatedImage = imageTheLights
        
        //[self.view .addSubview(self.imageLights)]
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordReset(sender: AnyObject) {
        let email = self.emailField.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Send a request to reset a password
        PFUser.requestPasswordResetForEmailInBackground(finalEmail)
        
        let alert = UIAlertController (title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalEmail + ".", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
