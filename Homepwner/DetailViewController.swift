//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Dylan Bruschi on 2/23/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - UI outlets
    
    @IBOutlet var nameField: ItemTextField!
    @IBOutlet var serialNumberField: ItemTextField!
    @IBOutlet var valueField: ItemTextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    
    var imageStore: ImageStore!
    
    // MARK: - Number and date formatters
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    // MARK: - Tapping Background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    // MARK: - Taking and clearing picture
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        // If the device has a camera, take a picture; otherwise,
        //just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = true
            imagePicker.cameraCaptureMode = .photo
            
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            //customView stuff
            let customViewController = CustomOverlayViewController(
                nibName:"CustomOverlayViewController",
                bundle: nil
            )
            let customView:CustomOverlayView = customViewController.view as! CustomOverlayView
            customView.frame = imagePicker.view.frame
            
        }
        else {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
        }
        
        
        
        // Place image on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
   
    
    @IBAction func clearImage(_ sender: UIBarButtonItem) {
        imageView.image = nil
        imageStore.deleteImageForKey(key: item.itemKey)
    }
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    // MARK: - Image picker controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image: image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take the image picker off the screen
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated as Date)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.imageForKey(key: key)
        imageView.image = imageToDisplay
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        }
        else {
            item.valueInDollars = 0
        }
    }
    
    // MARK: - Textfield methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DateChangeSegue" {
            
            let item = self.item
            let dateChangeViewController = segue.destination as! DateChangeViewController
            dateChangeViewController.item = item
            }
        }

}
