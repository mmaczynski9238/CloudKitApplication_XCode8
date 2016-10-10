//
//  SDetailViewController.swift
//  CloudKitApplication
//
//  Created by Michael Maczynski on 10/9/16.
//  Copyright © 2016 Michael Maczynski. All rights reserved.
//


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


import UIKit
import CloudKit

class SDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentStudent = Students()
    let imagepicker = UIImagePickerController()
    
    var savedImage = UIImage()
    
    @IBOutlet var schoolLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    let publicData = CKContainer.defaultContainer().publicCloudDatabase
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        imagepicker.delegate = self
        
        
        self.navigationItem.title = currentStudent.name
        
        imageView.image = currentStudent.image
        
    }
    
    
    @IBAction func uploadImageButton(sender: UIBarButtonItem) {
        uploadUser()
    }
    
    
    func uploadUser(){
        
        let newUser = CKRecord(recordType: "CurrentUser")
        
        
        if nameTextField.text != ""  {
            newUser["namecontent"] = nameTextField.text
            
            self.publicData.saveRecord(newUser, completionHandler: { (record:CKRecord?, error:NSError?) -> Void in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //self.tableView.beginUpdates()
                        // self.names.insert(newName, atIndex: 0)
                        //let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        //self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                        //self.tableView.endUpdates()
                        print("Name Saved Successfully")
                    })
                }else{
                    print(error)
                }
            })
            
        }
        
        
        let data = UIImagePNGRepresentation(savedImage); // UIImage -> NSData, see also UIImageJPEGRepresentation
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(NSUUID().UUIDString+".dat")
        do {
            try data!.writeToURL(url!, options: [])
        } catch let e as NSError {
            print("Error! \(e)");
            return
        }
        newUser["photocontent"] = CKAsset(fileURL: url!)
        
        // ...
        
        publicData.saveRecord(newUser, completionHandler: { (record: CKRecord?, error: NSError?) in
            // Delete the temporary file
            do { try NSFileManager.defaultManager().removeItemAtURL(url!) }
            catch let e { print("Error deleting temp file: \(e)") }
            
            // ...
        })
        
    }
    
    @IBAction func cameraButton(sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            imagepicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagepicker, animated: true, completion: nil)
        }
        else
        {
            imagepicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(imagepicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func importPhotoButton(sender: UIBarButtonItem) {
        
        imagepicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagepicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        imagepicker.dismissViewControllerAnimated(true, completion: {
            
            
            var selectedImage = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            self.savedImage = selectedImage
            self.imageView.image = selectedImage
        })
        
        
    }
    
    
    
}


