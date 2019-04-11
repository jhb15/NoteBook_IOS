//
//  SelectNoteTableViewController.swift
//  NoteBook
//
//  Created by jhb15 on 10/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class SelectNoteTableViewController: UITableViewController {
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsNotes: NSFetchedResultsController<Note>?
    var fetchedResultsLinks: NSFetchedResultsController<Link>?
    var article: GuardianOpenPlatformResult?
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)

        cell.textLabel?.text = fetchedResultsNotes?.object(at: indexPath).title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Check if we already store a Link of this type
        var link = doesLinkExist(id: article!.id)
        
        if link == nil {
            //Create Link
            link = Link(entity: Link.entity(), insertInto: managedContext)
            link!.id = article!.id
            link!.url = article!.webUrl
            link!.title = article!.webTitle
        }
        
        let note = fetchedResultsNotes?.object(at: indexPath)
        note?.addToLinks(link!)
        note?.updated_at = Date() //Updateing updated-at timestamp
        
        do {
            try managedContext?.save()
            print("note added")
        }
        catch let error as NSError {
            print("error with \(error)")
        }
        
        dismiss(animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
