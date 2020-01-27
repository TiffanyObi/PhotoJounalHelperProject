//
//  DisplayPhotoJounalViewController.swift
//  PhotoJounalHelperProject
//
//  Created by Tiffany Obi on 1/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class DisplayPhotoJounalViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageObjects = [ImageObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }

    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         
         let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
         
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         
        let editAction = UIAlertAction(title: "Edit", style: .default)
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
         alertController.addAction(cancelAction)
     
        present(alertController,animated: true)

    }
    
}
 

extension DisplayPhotoJounalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "journalCell", for: indexPath) as? ImageJournalCollectionViewCell else {
            fatalError("could not downcast to  ImageJournalCollectionViewCell ")
        }
        
        let cellInRow = imageObjects[indexPath.row]
        
        cell.configureCell(for: cellInRow)
        return cell
    }
    
  
}
