//
//  CacheTableViewController.swift
//  NoteBook
//
//  Created by jhb15 on 14/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class CacheTableViewController: UITableViewController {

    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<ResponseCache>?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ResponseCache>(entityName: "ResponseCache")
        let sortDescriptor = NSSortDescriptor(key: "expiryDate", ascending: false, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performFetchForController()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CacheCell", for: indexPath)

        cell.textLabel?.numberOfLines = 5
        let cachedRes = fetchedResultsController?.object(at: indexPath)
        let str = cachedRes?.expiryDate?.description ?? "nil"
        cell.textLabel?.text = (cachedRes?.key ?? "Unknown") + "[Date: " + str + "]"

        return cell
    }

}
