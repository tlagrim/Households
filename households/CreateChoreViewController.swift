//
//  CreateChoreViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 1/30/16.
//
//

import Foundation
import UIKit

class CreateChoreViewController: UIViewController {
    
    @IBOutlet weak var choreImage: UIImageView!
    @IBOutlet weak var choreTitle: UITextField!
    
    var username: String?
    
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
        choreTitle.resignFirstResponder()
        var pictureData: NSData
        
        if (choreImage.image != nil){
            pictureData = UIImagePNGRepresentation(choreImage.image!)!
        } else {
            pictureData = UIImagePNGRepresentation(UIImage(named: "chore.jpg")!)!
        }
        
        //Upload a new picture
        //1
        let file = PFFile(name: "chore_image", data: pictureData)
        
        //TRYING TO FIND A WAY FOR IMAGE SIZE CHECKER
        file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                //2
                self.saveNewChoreEntry(file!)
            } else if let error = error {
                //3
                print("there is an error while saveInBackgroundWithBlock",error)
            }
        })
        
    }
    
    
    func saveNewChoreEntry(file: PFFile)
    {
        //1
        // TAKE NOTE OF NUMOCCUPANTS
        let chore = Chore(title: choreTitle.text, image: file)
        //2
        chore.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                print("Created new household successfully")/*
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HouseholdsOverview")
                self.presentViewController(viewController, animated: true, completion: nil)
                }) */
                self.navigationController?.popViewControllerAnimated(true)
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

extension CreateChoreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        choreImage.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}