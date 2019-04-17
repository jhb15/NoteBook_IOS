//
//  SelectNoteTableViewController.swift
//  NoteBook
//
//  Created by (Student Number: 140159095) on 10/04/2019.
//  Copyright © 2019 Aberystwyth Univerity. All rights reserved.
//

import UIKit
import CoreData

class SelectNoteTableViewController: UITableViewController {
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsNotes: NSFetchedResultsController<Note>?
    var fetchedResultsLinks: NSFetchedResultsController<Link>?
    var article: GuardianOpenPlatformResult?
    var link: Link?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
        
        let fetchRequestNote = NSFetchRequest<Note>(entityName: "Note")
        let sortDescriptorNote = NSSortDescriptor(key: "created_at", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequestNote.sortDescriptors = [sortDescriptorNote]
        
        let fetchRequestLink = NSFetchRequest<Link>(entityName: "Link")
        let sortDescriptorLink = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequestLink.sortDescriptors = [sortDescriptorLink]
        
        fetchedResultsNotes = NSFetchedResultsController(fetchRequest: fetchRequestNote, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsLinks = NSFetchedResultsController(fetchRequest: fetchRequestLink, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
        
        link = doesLinkExist(id: article!.id)
    }
    
    @IBAction func cancelAddingToNote(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performFetchForController()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsNotes?.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT_WITH_TIME
        
        if let note = fetchedResultsNotes?.object(at: indexPath) {
            cell.noteTitleLabel?.text = note.title
            var createdStr = "Unknown"; var updatedStr = "Unknown"
            if let created = note.created_at { createdStr = dateFormatter.string(from: created) }
            if let updated = note.updated_at { updatedStr = dateFormatter.string(from: updated) }
            cell.noteTimestampsLabel?.text = "Created: " + createdStr +  " Updated: " + updatedStr
            
            if link != nil && (note.links?.contains(link as Any)) ?? false {  //Disable Cell if Non Linkable
                cell.isUserInteractionEnabled = false
                cell.noteTitleLabel?.isEnabled = false
                cell.noteTimestampsLabel?.isEnabled = false
                cell.noteTitleLabel?.text?.append(" -- (Already Linked)")
            } else {
                cell.isUserInteractionEnabled = true
                cell.noteTitleLabel?.isEnabled = true
                cell.noteTimestampsLabel?.isEnabled = true
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Check if we already store a Link of this type
        
        if link == nil {
            //Create Link
            link = Link(entity: Link.entity(), insertInto: managedContext)
            link!.id = article!.id
            link!.url = article!.webUrl
            link!.title = article!.webTitle
        }
        
        let note = fetchedResultsNotes?.object(at: indexPath)
        
        /*if note.links.contains(link) {
            
        }*/ //ADD Check to see if link already added to 
        
        note?.addToLinks(link!)
        note?.updated_at = Date() //Updateing updated-at timestamp
        
        do {
            try managedContext?.save()
            print("note added")
        }
        catch let error as NSError {
            print("error with \(error)")
        }
        
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func doesLinkExist(id: String) -> Link? {
        if let links = fetchedResultsLinks?.fetchedObjects {
            for link in links {
                if link.id == id {
                    return link
                }
            }
        }
        return nil
    }
    
    func performFetchForController() {
        do {
            try fetchedResultsNotes?.performFetch()
            try fetchedResultsLinks?.performFetch()
            tableView.reloadData()
        }
        catch let error as NSError {
            print("The error was: \(error)")
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
