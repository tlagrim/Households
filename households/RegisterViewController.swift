//
//  RegisterViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 1/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    // format:
    // 2016-01-30T22:21:32.645Z
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    //@IBOutlet var imageLights: FLAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let imageTheLights: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("lights", ofType: "gif")!))
        //self.imageLights.animatedImage = imageTheLights
        //[self.view .addSubview(self.imageLights)]
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        //TRYING TO FIND A WAY FOR IMAGE SIZE CHECKER
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        let username = self.userTextField.text
        let password = self.passwordTextField.text
        let email = self.emailTextField.text
        let fname = self.firstName.text
        let lname = self.lastName.text
        let phoneNum = self.phoneNumber.text
        let finalPhoneNum:Int? = Int(phoneNum!)
        let pictureData = UIImagePNGRepresentation(imageToUpload.image!)
    
        //Upload a new picture
        //1
        let file = PFFile(name: "image", data: pictureData!)
        
        if username!.characters.count <= 5 {
            let alert = UIAlertView(title: "Username not long enough!", message: "For your safety, username must be greater than 5 characters", delegate: self, cancelButtonTitle: "Aight")
            alert.show()
            
        } else if password!.characters.count == 0 {
            let alert = UIAlertView(title: "Empty password!", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password!.characters.count < 5 {
            let alert = UIAlertView(title: "Password not long enough!", message: "For your safety, password must be greater than 5 characters", delegate: self, cancelButtonTitle: "Aight fam")
            alert.show()
            
        } else if email!.characters.count < 5 {
            let alert = UIAlertView(title: "Invalid email!", message: "Please enter a valid email address.", delegate: self, cancelButtonTitle: "Gotcha")
            alert.show()
            
        } else {
            let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            //1
            let user = PFUser()
            
            //2
            user.username = username
            user.password = password
            user.email = finalEmail
            user["phone_number"] = finalPhoneNum
            user["first_name"] = fname
            user["last_name"] = lname
            user["image"] = file
            
            
            
            //3
            user.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                } else {
                    print("New account creation successful")
                    let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HouseholdsOverview")
                        self.presentViewController(viewController, animated: true, completion: nil)
                        //self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
                    })
                }
            })
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        imageToUpload.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
