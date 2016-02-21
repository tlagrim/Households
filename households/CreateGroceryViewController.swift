//
//  CreateGroceryViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/9/16.
//
//

import Foundation
import UIKit

class CreateGroceryViewController: UIViewController {
    
    @IBOutlet weak var groceryItemName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var store: UITextField!
    @IBOutlet weak var detail: UITextField!
    @IBOutlet weak var groceryImage: UIImageView!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
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
    
    
    
    @IBAction func createPressed(sender: AnyObject) {
        
        groceryItemName.resignFirstResponder()
        price.resignFirstResponder()
        let thePrice = self.price.text
        
        let finalPrice: Int = Int(thePrice!)!
        
        //Disable the send button until we are ready
        navigationItem.rightBarButtonItem?.enabled = false
        
        loadingSpinner.startAnimating()
        
        let pictureData = UIImagePNGRepresentation(groceryImage.image!)
        // print("Original Photo works")
        
        
        //Upload a new picture
        //1
        let file = PFFile(name: "household_image", data: pictureData!)
        
        //TRYING TO FIND A WAY FOR IMAGE SIZE CHECKER
        file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                //2
                self.saveNewGroceryEntry(file!, finalPrice: finalPrice)
            } else if let error = error {
                //3
                print("there is an error while saveInBackgroundWithBlock",error)
            }
            }, progressBlock: { percent in
                //4
                print("Uploaded: \(percent)%")
        })
        
        
    }
    
    
    func saveNewGroceryEntry(file: PFFile, finalPrice: Int)
    {
        //1
        // TAKE NOTE OF NUMOCCUPANTS
        let grocery = Grocery(creator: PFUser.currentUser()!, name: groceryItemName.text, price: finalPrice, brand_name: brandName.text, store: store.text, detail: detail.text, image: file)
        
        //2
        grocery.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                print("Created new grocery successfully")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
            } else {
                //4
                if let errorMessage = error?.userInfo["error"] as? String {
                    print("Error! In saving saveNewGrocery\n",errorMessage)
                }
            }
        }
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension CreateGroceryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        groceryImage.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}