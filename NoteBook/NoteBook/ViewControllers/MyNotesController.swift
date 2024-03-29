//
//  MyNotesController.swift
//  NoteBook
//
//  Created by (Student Number: 140159095) on 02/04/2019.
//  Copyright © 2019 Aberystwyth Univerity. All rights reserved.
//

import UIKit
import CoreData

/**
 Class connected to the My Notes Table View in the storyboard.
 */
class MyNotesController: UITableViewController, UISearchResultsUpdating {
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Note>?
    
    var filteredTableData = [Note]()
    var resultSearchController = UISearchController()
    
    var editIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This part of the code initalizes the search bar, I had no idea how to do this. But thanks to
        // a tutorial by Arthur Knopper at https://www.ioscreator.com/tutorials/add-search-table-view-ios-tutorial
        // I added this.
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
        let sortDescriptor = NSSortDescriptor(key: "updated_at", ascending: false, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*var contentOffset: CGPoint = tableView.contentOffset
        contentOffset.y += (tableView.tableHeaderView?.frame)!.height
        self.tableView.contentOffset = contentOffset*/
        
        performFetchForController()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let notes = fetchedResultsController?.fetchedObjects,
            notes.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        }
        let noDataLabel = UILabel()
        noDataLabel.text = "You do not have any notes to display."
        noDataLabel.textColor = UIColor.gray
        noDataLabel.textAlignment = .center
        tableView.separatorStyle = .none
        tableView.backgroundView = noDataLabel
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredTableData.count
        }
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT_WITH_TIME
        
        let note: Note
        if resultSearchController.isActive {
            note = filteredTableData[indexPath.row]
        } else {
            note = (fetchedResultsController?.object(at: indexPath))!
        }
        
        cell.noteTitleLabel?.text = note.title ?? "Unknown"
        var createdStr = "Unknown"; var updatedStr = "Unknown"
        if let created = note.created_at { createdStr = dateFormatter.string(from: created) }
        if let updated = note.updated_at { updatedStr = dateFormatter.string(from: updated) }
        cell.noteTimestampsLabel?.text = "Created: " + createdStr +  " Updated: " + updatedStr
     
        return cell
     }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /*let edit = UITableViewRowAction(style: .normal, title: "Edit") { //Disabled due to not functioning properly. Need to fix
            action, index in
            self.editIndexPath = index
            self.performSegue(withIdentifier: "NoteDetailSegue", sender: action) For some reason prepare for segue isn't called??
        }
        edit.backgroundColor = UIColor.lightGray*/
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
        return [delete/*, edit*/]
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
    
    /**
     This function is used to update the list of notes based on what is entered into the search bar. A lot of help
     for this came from users Onur Var and Peter Kreinz on Stack Overflow.
     
     Answer can be found at: https://stackoverflow.com/a/34213751
     */
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", searchController.searchBar.text!)
        let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", searchController.searchBar.text!)
        let searchPredicate = NSCompoundPredicate(type: .or, subpredicates: [titlePredicate, contentPredicate])
        let notes = fetchedResultsController?.fetchedObjects
        let nsNotes = NSArray(array: notes!)
        let filteredNotes = nsNotes.filtered(using: searchPredicate) as! [Note]
        filteredTableData = filteredNotes
        
        tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let view = segue.destination as? NoteDetailController,
            let indexPath = tableView.indexPathForSelectedRow,
            let ctx = managedContext {
            view.managedContext = ctx
            view.noteItem = fetchedResultsController?.object(at: indexPath)
            /*if let action = sender as? UITableViewRowAction,
                let title = action.title,
                title == "Edit" {
                view.noteItem = fetchedResultsController?.object(at: editIndexPath!)
                view.isEditable = true
            }*/
            
        }
        
        resultSearchController.isActive = false
    }

}
