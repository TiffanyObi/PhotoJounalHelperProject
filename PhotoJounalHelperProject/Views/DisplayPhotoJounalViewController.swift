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
    
    
    
    public var imageObjects = [ImageObject](){
        didSet{
                 print("journals\(imageObjects.count)")
            collectionView.reloadData()
            
        }
    }
    
    
    var dataPersistance = PersistenceHelper(filename: "photo.plist")
    
//    init?(coder:NSCoder, journals:[ImageObject], dataPersistance:PersistenceHelper){
//           self.imageObjects = journals
//           self.dataPersistance = dataPersistance
//           super.init(coder: coder)
//       }
//       
//       required init?(coder: NSCoder) {
//           fatalError("init(coder:) has not been implemented")
//       }
       
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        print("view will appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
   
        loadJournals()
        print("view did load")
    }
  
    
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        
        let editViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddAndEditJounalsViewController") { (coder) in
            return AddAndEditJounalsViewController(coder: coder, imageObject: nil, indexPath: nil)
        }

        present(editViewController, animated: true, completion: nil)
        
        
    }
    
    
    func loadJournals() {
        do {
            try  imageObjects = dataPersistance.loadEvents()
            
        }  catch {
            print(error)
        }
        
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
        cell.senderTag = indexPath.row
        cell.viewController = self
        //        cell.imageObjects = imageObjects
        cell.configureCell(for: cellInRow)
        
        cell.editJournalDelegate = self
        return cell
    }
    
    
}


extension DisplayPhotoJounalViewController: EditPhotoJournal {
    func didBeginEditingJournal(_ imageJournalCollectionViewCell: ImageJournalCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: imageJournalCollectionViewCell) else { return}
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {[weak self] deleteAction in
            do {
                try
                    self?.dataPersistance.delete(event: indexPath.row)
                
                self?.loadJournals()
            } catch {
                print("could not delete\(error)")
            }
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] editAction in
            
            
            let editViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddAndEditJounalsViewController") { (coder) in
                return AddAndEditJounalsViewController(coder: coder, imageObject: (self?.imageObjects[indexPath.row])!, indexPath: indexPath)
            }
            
            self?.present(editViewController, animated: true, completion: nil)
            
            
            
        }
        
        
        
        
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true)
        
    }
    
    
}




