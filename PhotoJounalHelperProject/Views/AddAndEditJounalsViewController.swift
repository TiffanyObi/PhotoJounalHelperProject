//
//  AddAndEditJounalsViewController.swift
//  PhotoJounalHelperProject
//
//  Created by Tiffany Obi on 1/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import AVFoundation

enum PhotoState {
    case existingPhoto
    case newPhoto
}

protocol UpdatePhotoJournal:AnyObject {
    func didSaveJournal(imageObject:ImageObject, state: PhotoState)
    
}

class AddAndEditJounalsViewController: UITableViewController {
    
    @IBOutlet weak var saveJournalButton: UIButton!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var descriptionTextFeild: UITextField!
    
    
    private var imagePickerController = UIImagePickerController()
    
    private var descriptionText = ""
    
    
    weak var journalDelegate: UpdatePhotoJournal?
    
//    weak var editJournalDelegate: EditPhotoJournal?
    
    var selectedImage:UIImage? {
        didSet {
            selectedImageView.image = selectedImage
        }
    }
    
    
    public var photoState = PhotoState.newPhoto
    
    var imagesObject: ImageObject!
    //    var allObjects = [ImageObject]()
    var senderTag = 0
    var indexPath: IndexPath!
    
    var dataPersistance = PersistenceHelper(filename: "photo.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        descriptionTextFeild.delegate = self
        editUpdate()
        //        loadJournals()
        //        print(indexPath.row)
        print("This is the photoState \(photoState)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        saveJournalButton.isHidden = true
    }
    
    init?(coder:NSCoder, imageObject: ImageObject?, indexPath: IndexPath?){
        self.imagesObject = imageObject
        self.indexPath = indexPath
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    func loadJournals() {
    //        do {
    //            try  allObjects = dataPersistance.loadEvents()
    //
    //        }  catch {
    //            print(error)
    //        }
    //
    //    }
    
    @IBAction func cancelButtonPressed(cancelButton: UIButton) {
        
        navigationController?.popViewController(animated: true)
        return
    }
    
    private func editUpdate(){
        if imagesObject != nil {
            saveJournalButton.titleLabel?.text = "Update"
            photoState = .existingPhoto
            selectedImage = UIImage(data: imagesObject.imageData)
            descriptionTextFeild.text = imagesObject.description
        }
    }
    
    
    private func showImageController(isCameraSelected:Bool) {
        //source type default will be .photoLibrary
        
        imagePickerController.sourceType = .photoLibrary
        
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
    @IBAction func saveButtonGotPressed(_ sender: UIButton) {
        appendNewPhotoToCollection()
        dismiss(animated: true) {
            
            
        }
        
        
        
        
    }
    
    
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {[weak self]
            alertAction in
            self?.showImageController(isCameraSelected: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
    }
    
    
    
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(cameraAction)
            
        } else {
            alertController.addAction(cancelAction)
        }
        present(alertController,animated: true)
    }
    
    
    
    
    func appendNewPhotoToCollection() {
        
        if photoState == .newPhoto {
            
            guard let image = selectedImage else {
                return
            }
            
            print("original image size is : \(image.size)")
            
            //the size for the resizing of the image
            
            let size = UIScreen.main.bounds.size
            
            // we will maintain the aspect:ratio of the image
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
            
            
            // resize image
            let resizedImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
            
            guard let imageData = resizedImage.jpegData(compressionQuality: 1.0) else {
                print("image is nil")
                return
            }
            print("resizedImage image size is : \(resizedImage.size)")
            // here we need to create an image object
            
            imagesObject = ImageObject(description: descriptionText, imageData: imageData, date: Date())
            
            //            allObjects.insert(imageObject, at: 0)
            
            
            do {
                try dataPersistance.create(item: imagesObject) } catch {
                    print(error)
            }
            
            
        } else if photoState == .existingPhoto {
            
            guard let indexpath = indexPath else { return }
            
            imagesObject = ImageObject(description: descriptionTextFeild.text ?? "no text", imageData: imagesObject.imageData, date: Date())
            
            dataPersistance.update(indexPath: indexpath, newItem: imagesObject)
            
        }
        
        
        journalDelegate?.didSaveJournal(imageObject: imagesObject, state: .existingPhoto)
    }
    
}

extension AddAndEditJounalsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        we need to access the UIImagePickerController.InfoKey.origainalImage key to get the UIImage that was selected.
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            print("Image selection not found")
            return
        }
        
        selectedImage = image
        
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}



extension AddAndEditJounalsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        descriptionText = textField.text ?? "No Comment"
        saveJournalButton.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}


extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    
}

