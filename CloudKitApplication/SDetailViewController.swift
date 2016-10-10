//
//  SDetailViewController.swift
//  CloudKitApplication
//
//  Created by Michael Maczynski on 10/9/16.
//  Copyright © 2016 Michael Maczynski. All rights reserved.
//

import UIKit

class SDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentStudent = Students()
    let imagepicker = UIImagePickerController()
    
    @IBOutlet var schoolLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker.delegate = self
        
        
        self.navigationItem.title = currentStudent.name
        
        imageView.image = UIImage(named: currentStudent.image)
        
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
            self.imageView.image = selectedImage
        })
        
        
    }
    
    
    
}


