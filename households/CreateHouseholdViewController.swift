//
//  CreateHouseholdViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 1/30/16.
//
//

import Foundation
import UIKit

class CreateHouseholdViewController: UIViewController {
    
    @IBOutlet weak var householdNameTextField: UITextField!
    @IBOutlet weak var householdKeyTextField: UITextField!
    @IBOutlet weak var householdTypeTextField: UITextField!
    @IBOutlet weak var householdStreetAddressTextField: UITextField!
    @IBOutlet weak var householdCityTextField: UITextField!
    @IBOutlet weak var householdStateTextField: UITextField!
    // add numbers only input field
    @IBOutlet weak var householdZipTextField: UITextField!
    @IBOutlet weak var householdImageToUpload: UIImageView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var householdCountryTextField: UITextField!
    
    @IBOutlet weak var buildHouseholdButton: UIButton!
    var username: String?
    
    override func viewDidLoad() {
        print("adfadsfdsf")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func isEmptyField() -> Bool {
        print(self.householdNameTextField.text)
        
        if self.householdNameTextField.text == "" {
            print("Household name field is empty")
            return true
        } else  if self.householdKeyTextField.text == "" {
            print("Household key field is empty")
            return true
        } else {
            print("They are okay")
            return false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        print("inside createhouseholdVC")
        
    }
    
    @IBAction func selectPicturePressed(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
        //TRYING TO FIND A WAY FOR IMAGE SIZE CHECKER
    }
    
    
    
    @IBAction func buildHouseholdPressed(sender: AnyObject) {
        if isEmptyField() == true {
            print("Check required fields.")
        } else {
            householdNameTextField.resignFirstResponder()
            householdKeyTextField.resignFirstResponder()
            let zip = self.householdZipTextField.text
            var finalZip: Int = 0
            
            if zip == nil {
                finalZip = Int(zip!)!
            }
            
            //Disable the send button until we are ready
            navigationItem.rightBarButtonItem?.enabled = false
            
            loadingSpinner.startAnimating()
            
            
            var pictureData: NSData
            
            if (householdImageToUpload.image != nil){
                pictureData = UIImagePNGRepresentation(householdImageToUpload.image!)!
            } else {
                pictureData = UIImagePNGRepresentation(UIImage(named: "houseplaceholder.png")!)!
            }
            
            //Upload a new picture
            //1
            let file = PFFile(name: "household_image", data: pictureData)
            
            //TRYING TO FIND A WAY FOR IMAGE SIZE CHECKER
            file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded {
                    //2
                    self.saveNewHouseholdEntry(file!, finalZip: finalZip)
                } else if let error = error {
                    //3
                    print("there is an error while saveInBackgroundWithBlock",error)
                }
                }, progressBlock: { percent in
                    //4
                    print("Uploaded: \(percent)%")
            })
        }
    }
    
    
    func saveNewHouseholdEntry(file: PFFile, finalZip: Int)
    {
        //1
        // TAKE NOTE OF NUMOCCUPANTS
        let household = Household(name: householdNameTextField.text, image: file, creator: PFUser.currentUser()!, numOccupants: 1, type: householdTypeTextField.text, streetAddress: householdStreetAddressTextField.text, city: householdCityTextField.text, state: householdStateTextField.text, zip: finalZip, country: householdCountryTextField.text!, key: householdKeyTextField.text)
        //2
        household.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                print("Created new household successfully")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HouseholdsOverview")
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
            } else {
                //4
                if let errorMessage = error?.userInfo["error"] as? String {
                    print("Error!",errorMessage)
                }
            }
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

extension CreateHouseholdViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        householdImageToUpload.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}