//
//  ViewController.swift
//  iosFinalProject
//
//  Created by Siamak Mohseni Sam on 2017-04-19.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate{
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var searchTextField: UISearchBar!
    
    
    var controller : NSFetchedResultsController<Table_iTunes>!
    
    
    let inputFromWeb = InputFromWeb()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        attemptFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if let myVC = destinationVC as? PopupViewController,
            let identifier = segue.identifier ,
            let sender = sender as? Table_iTunes
        {
            if identifier == "ItemDetailsVC" {
                myVC.item = sender
            }
        }
        
    }
    
    
    // MARK:  Tables methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            return sections[section].numberOfObjects
            
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierCell", for: indexPath) as! TableViewCell
        updateCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    func updateCell(cell : TableViewCell, indexPath : NSIndexPath){
        let item = controller.object(at: indexPath as IndexPath)
        cell.updateCell(item: item)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects  {
            if objs.count > 0 {
                let item = objs[indexPath.row]
                performSegue(withIdentifier: "ItemDetailsVC", sender: item)
            }
            
        }
    }
    
   //MARK: CoreData methods
    
    func attemptFetch(){
        
        let fetchRequest : NSFetchRequest<Table_iTunes> = Table_iTunes.fetchRequest()
        let kindSort  = NSSortDescriptor(key: "kind", ascending: false)
        fetchRequest.sortDescriptors = [kindSort]
        
         controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try controller.performFetch()}
        catch{
            let error = error as NSError
            print("\(error)")
            
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
                updateCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    func cleanCorData()
    {
        let reqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "Table_iTunes")
        let delAllReqVar = NSBatchDeleteRequest(fetchRequest: reqVar)
        do { try context.execute(delAllReqVar) }
        catch { print(error) }
        
        
    }
    
    // MARK: Get data and Convert JSON
    
    func fillDatabase(artistNameOfURL: String, kindOfURL: String)
    {
        cleanCorData()
        let inputFromWeb = InputFromWeb()
        let results = inputFromWeb.downloadVariables(artistNameOfURL: artistNameOfURL, kindOfURL: kindOfURL)
        
        // Array ************
        for result in results {
            
            // Dictionary   ***************
            
            let item = Table_iTunes(context: context)
            item.kind = result["kind"] as? String
            item.artistName = result["artistName"] as? String
            
            if let price = result["price"] as? Double{
                item.price = String(price)
            }
            if let price = result["collectionPrice"] as? Double{
                item.price = String(price)
            }
            
            item.information = result["description"] as? String
            item.information = result["trackCensoredName"] as? String
            item.trackName = result["trackName"] as? String
            
            let urlString = result["artworkUrl100"] as? String
            
            if let myurl = urlString{
                
                let imageURL = URL(string: myurl)
                
                if let url = imageURL {
                    do{
                        let urlContents = try Data(contentsOf: url)
                        item.image = UIImage(data: urlContents)
                    }catch{print("error")}
                }
            }
        }
        
        appDelegate.saveContext()
    }
    
    // MARK: Search Bar
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            spinner.startAnimating()}
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var type = ""
        if segment.selectedSegmentIndex == 0 {
            type = ""
        }
        if segment.selectedSegmentIndex == 1 {
            type = "song"
        }
        if segment.selectedSegmentIndex == 2 {
            type = "software"
        }
        if segment.selectedSegmentIndex == 3 {
            type = "ebook"
        }
        
        if let search = searchTextField.text {
            
            fillDatabase(artistNameOfURL: search, kindOfURL: type)
            attemptFetch()
            tableView.reloadData()
            spinner?.stopAnimating()
        }
    }
 
    // MARK: Orientation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        if UIDevice.current.orientation.isLandscape{
            
            let storybord = UIStoryboard(name: "Main", bundle: nil)
            
            let vc : CollectionViewController = storybord.instantiateViewController(withIdentifier: "storyCollection") as! CollectionViewController
            self.dismiss(animated: true, completion: nil)
            self.present(vc, animated: true, completion: nil)
            
        }
        else {
            
            let storybord = UIStoryboard(name: "Main", bundle: nil)
            
            let vc : ViewController = storybord.instantiateViewController(withIdentifier: "storyTable") as! ViewController
            
            self.dismiss(animated: true, completion: nil)
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    
    
    
    
    
    
}




















