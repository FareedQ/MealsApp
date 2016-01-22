//
//  cameraFunVC.swift
//  MealsApp
//
//  Created by FareedQ on 2016-01-22.
//  Copyright © 2016 FareedQ. All rights reserved.
//

import UIKit
import AVFoundation

class cameraFunVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self;
    }
    
    @IBOutlet weak var currentImage: UIImageView!

    let imagePicker = UIImagePickerController()
    
    @IBAction func takePicture(sender: UIButton) {
        imagePicker.sourceType = .Camera
        imagePicker.cameraCaptureMode = .Photo
        self.presentViewController(imagePicker, animated: true, completion: {})
    }
    
    @IBAction func button(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true) { () -> Void in
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        currentImage.image = image
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        print("Got an image")
//        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
//            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
//            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
//        }
//        imagePicker.dismissViewControllerAnimated(true, completion: {
//            
//        })
//    }
//    
//    func imageWasSavedSuccessfully(){
//        print("Yeah")
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        print("User canceled image")
//        dismissViewControllerAnimated(true, completion: {
//            // Anything you want to happen when the user selects cancel
//        })
//    }
    
    func postAlert(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: .Default) { (UIAlertAction) -> Void in
        }
        alert.addAction(okay)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
