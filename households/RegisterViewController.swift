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
    var alertTitle: String = ""
    var alertMessage: String = ""
    @IBOutlet var imageRegisterBackground: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageTheRegisterBackground: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("studylapse", ofType: "gif")!))
        self.imageRegisterBackground.animatedImage = imageTheRegisterBackground
        self.imageRegisterBackground.contentMode = UIViewContentMode.ScaleAspectFill
        [self.view .addSubview(self.imageRegisterBackground)]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        imageRegisterBackground.hidden = true
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        //TRYING TO FIND A WAY FOR IMAGE SIZE CHECKER
    }
    
    func showAlert(aTitle: String, aMessage: String) {
        print("Alert:\nTitle: ", aTitle, "\tMessage", aMessage)
        
        let alert = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    func allValidFields() -> Bool {
        alertTitle = ""
        alertMessage = ""
        var isAllValid = true
        if self.userTextField.text == "" || self.userTextField.text == nil {
            alertTitle = "Empty field!"
            alertMessage += "A Username is required. "
            isAllValid = false
        } else if self.userTextField.text?.characters.count <= 4 {
            alertTitle = "Username too short!"
            alertMessage += "For your safety, your Username must be at least 5 characters. "
            isAllValid = false
        } else if self.passwordTextField.text == "" || self.passwordTextField.text == nil {
            alertTitle = "Empty field!"
            alertMessage += "A Password is required. "
            isAllValid = false
        } else if self.passwordTextField.text?.characters.count <= 4 {
            alertTitle = "Security issue!"
            alertMessage += "To maximize security, your password must be at least 5 characters. "
            isAllValid = false
        } else if self.emailTextField.text == "" || self.emailTextField.text == nil {
            alertTitle = "Empty email address!"
            alertMessage += "An email address is required. "
            isAllValid = false
        } else if self.emailTextField.text?.characters.contains("@") == false || self.emailTextField.text?.characters.contains(".") == false {
            alertTitle = "Invalid email address!"
            alertMessage += "Double check your email address. "
            isAllValid = false
        } else if self.phoneNumber.text?.characters.count >= 1 && self.phoneNumber.text?.characters.count <= 10 {
            alertTitle = "Invalid phone number!"
            alertMessage += "Double check your phone number. "
            isAllValid = false
        }
        alertMessage += "Try again."
        return isAllValid
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        if allValidFields() == true {
            let username = self.userTextField.text
            let password = self.passwordTextField.text
            let email = self.emailTextField.text
            let fname = self.firstName.text
            let lname = self.lastName.text
            
            let phoneNum = self.phoneNumber.text
            var finalPhoneNum: Int = 0
            
            if self.phoneNumber.text == nil || self.phoneNumber.text?.characters.count <= 0 {
                finalPhoneNum = 0
            } else {
                finalPhoneNum = Int(phoneNum!)!
            }
            
            // let pictureData = UIImagePNGRepresentation(imageToUpload.image!)
            
            var pictureData = NSData()
            
            if (imageToUpload.image != nil){
                pictureData = UIImagePNGRepresentation(imageToUpload.image!)!
            } else {
                pictureData = UIImagePNGRepresentation(UIImage(named: "userplaceholder.png")!)!
            }
            
            
            //Upload a new picture
            //1
            let file = PFFile(name: "image", data: pictureData)
            
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
                    let alert5 = UIAlertController(title: "Error!", message:"Double check.", preferredStyle: .Alert)
                    alert5.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
                    self.presentViewController(alert5, animated: true){}
                } else {
                    print("New account creation successful")
                    
                    let alert5 = UIAlertController(title: "Welcome \(username!)!", message:"Your registration was successful.", preferredStyle: .Alert)
                    alert5.addAction(UIAlertAction(title: "Okay", style: .Default) { action -> Void in
                        // if this is the first time the user is logging in after registration
                        // if there is no occupancy where occupant == currentuser
                        // then alert and ask what you want the user to do.
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OccupancyDetail")
                            self.presentViewController(viewController, animated: true, completion: nil)
                            //self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
                        })
                        
                        })
                    self.presentViewController(alert5, animated: true){}
                }
            })
        } else {
            showAlert(alertTitle, aMessage: alertMessage)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        imageToUpload.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
