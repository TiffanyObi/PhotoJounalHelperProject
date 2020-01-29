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
    
    private var imageObjects = [ImageObject](){
        didSet{
           
            collectionView.reloadData()

        }
    }
    
     var dataPersistance = PersistenceHelper(filename: "photo.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        loadJournals()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addAndEditVC = segue.destination as? AddAndEditJounalsViewController else { return }
        
        addAndEditVC.journalDelegate = self
//
        
//        imageObjects.insert(addAndEditVC.imagesObject, at: 0)
        
    }
    
    func loadJournals() {
        do {
          try  imageObjects = dataPersistance.loadEvents()

        }  catch {
            print(error)
        }     }
    
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


extension DisplayPhotoJounalViewController: UpdatePhotoJournal {
    func didUpdateJournal(oldImageObject: ImageObject, newImageObject: ImageObject) {
        
    }
    
    
    func didSaveJournal(imageObject: ImageObject) {
        
        do {
            try dataPersistance.create(item: imageObject)} catch{print(error)}
        
        imageObjects.insert(imageObject, at: 0)
        print(imageObjects.count)
        let indexPath = IndexPath(row: 0, section: 0)

        //insert this new Cell into your collection view,
        collectionView.insertItems(at: [indexPath])
        
    }
    
    
}
