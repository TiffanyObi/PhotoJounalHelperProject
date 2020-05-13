//
//  ImageJournalCollectionViewCell.swift
//  PhotoJounalHelperProject
//
//  Created by Tiffany Obi on 1/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol EditPhotoJournal:AnyObject {
    func didBeginEditingJournal(_ imageJournalCollectionViewCell: ImageJournalCollectionViewCell )
}

class ImageJournalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
 
    weak var editJournalDelegate: EditPhotoJournal?
    
    var viewController:DisplayPhotoJounalViewController!
    
    var senderTag: Int?
    
//    public var imageObjects = [ImageObject]() {
//        didSet {
//            viewController.imageObjects = imageObjects
//        }
//    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        print("options button pressed- \(senderTag ?? -999)")
        
        editJournalDelegate?.didBeginEditingJournal(self)

    }
    
    
    
    func configureCell(for image: ImageObject){
        imageView.image = UIImage(data: image.imageData)
        
        descriptionTextView.text = image.description
    }
    
    
}

