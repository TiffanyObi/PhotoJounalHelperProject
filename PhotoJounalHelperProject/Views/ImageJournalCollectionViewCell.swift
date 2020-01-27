//
//  ImageJournalCollectionViewCell.swift
//  PhotoJounalHelperProject
//
//  Created by Tiffany Obi on 1/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class ImageJournalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
 
    
    func configureCell(for image: ImageObject){
        imageView.image = UIImage(systemName: "circle")
        
        descriptionTextView.text = " No comment"
    }
    
}
