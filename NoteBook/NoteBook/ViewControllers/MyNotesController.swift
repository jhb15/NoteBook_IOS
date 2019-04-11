//
//  MyNotesController.swift
//  NoteBook
//
//  Created by jhb15 on 02/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

/**
 Help for search bar came from: https://www.ioscreator.com/tutorials/add-search-table-view-ios-tutorial
 this also helped with defining the predicate: https://stackoverflow.com/questions/10611362/ios-coredata-nspredicate-to-query-multiple-properties-at-once#10614749
 */
class MyNotesController: UITableViewController, UISearchResultsUpdating {
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Note>?
    
    var filteredTableData = [Note]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var contentOffset: CGPoint = tableView.contentOffset
        contentOffset.y += (tableView.tableHeaderView?.frame)!.height
        self.tableView.contentOffset = contentOffset
        
        performFetchForController()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if resultSearchController.isActive {
            return filteredTableData.count
        }
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
     
        if resultSearchController.isActive {
            let note = filteredTableData[indexPath.row]
            cell.textLabel?.text = note.title ?? "Unknown"
        } else {
            let note = fetchedResultsController?.object(at: indexPath)
            cell.textLabel?.text = note?.title ?? "Unknown"
        }
     
        return cell
     }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") {
            action, index in
            print("Editing")
        }
        edit.backgroundColor = UIColor.lightGray
        let delete = UITableViewRowAction(style: .normal, title: "Delete") {
            action, index in
            if let note = self.fetchedResultsController?.object(at: index),
                let context = self.managedContext {
                do {
                    context.delete(note)
                    try context.save()
                    self.performFetchForController()
                    print("Note Deleted with index \(index)")
                }
                catch {
                    print("unable to delete entry")
                }
            }
        }
        delete.backgroundColor = UIColor.red
        return [delete, edit]
    }
    
    func performFetchForController() {
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
        catch let error as NSError {
            print("The error was: \(error)")
            
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        //TODO Filtering
        let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", searchController.searchBar.text!)
        let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", searchController.searchBar.text!)
        let searchPredicate = NSCompoundPredicate(type: .or, subpredicates: [titlePredicate, contentPredicate])
        let notes = fetchedResultsController?.fetchedObjects
        let nsNotes = NSArray(array: notes!)
        let filteredNotes = nsNotes.filtered(using: searchPredicate) as! [Note]
        filteredTableData = filteredNotes
        
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let view = segue.destination as? NoteDetailController,
            let indexPath = tableView.indexPathForSelectedRow {
            view.noteItem = fetchedResultsController?.object(at: indexPath)
        }
        
        resultSearchController.isActive = false
    }

}
