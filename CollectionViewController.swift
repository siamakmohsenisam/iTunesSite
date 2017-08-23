//
//  CollectionViewController.swift
//  iosFinalProject
//
//  Created by Siamak Mohseni Sam on 2017-04-20.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
     var controller : NSFetchedResultsController<Table_iTunes>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        attemptFetch()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = controller.sections{
            return sections[section].numberOfObjects
            
        }
        return 0
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
       
        updateCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    func updateCell(cell : CollectionViewCell, indexPath : NSIndexPath){
        let item = controller.object(at: indexPath as IndexPath)
        cell.updateCell(item: item)
    }
    
  //               ===========================
    
    func attemptFetch(){
        
        let fetchRequest : NSFetchRequest<Table_iTunes> = Table_iTunes.fetchRequest()
        let kindSort  = NSSortDescriptor(key: "kind", ascending: false)
        fetchRequest.sortDescriptors = [kindSort]
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do{
            try controller.performFetch()}
        catch{
            let error = error as NSError
            print("\(error)")
            
        }
    }
    
    //*********************
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.up
//    }
//    
//    
//    
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.endUpdates()
//    }
    
    //********************************
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                collectionView.insertItems(at: [indexPath])
            }
            break
        case .delete:
            if let indexPath = indexPath{
                collectionView.deleteItems(at: [indexPath])
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
                updateCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath{
                collectionView.deleteItems(at: [indexPath])
            }
            if let indexPath = newIndexPath{
                collectionView.insertItems(at: [indexPath])
            }
            break
            
        }
    }

    
    
    
    
    
    
}




















