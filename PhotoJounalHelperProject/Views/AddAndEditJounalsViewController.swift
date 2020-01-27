//
//  AddAndEditJounalsViewController.swift
//  PhotoJounalHelperProject
//
//  Created by Tiffany Obi on 1/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class AddAndEditJounalsViewController: UITableViewController {

    @IBOutlet weak var saveJournalButton: UIButton!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var descriptionTextFeild: UITextField!
    
    private var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
imagePickerController.delegate = self
    }


    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    

   private func showImageController(isCameraSelected:Bool) {
       //source type default will be .photoLibrary
       
       imagePickerController.sourceType = .photoLibrary
       
       if isCameraSelected {
           imagePickerController.sourceType = .camera
   }
   present(imagePickerController, animated: true)
   }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
        
    }
    

}

extension AddAndEditJounalsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        we need to access the UIImagePickerController.InfoKey.origainalImage key to get the UIImage that was selected.
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            print("Image selection not found")
            return
        }
        
        selectedImageView.image = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
dismiss(animated: true)
    }
}

extension AddAndEditJounalsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
