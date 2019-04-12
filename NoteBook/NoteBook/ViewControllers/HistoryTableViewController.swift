//
//  HistoryTableViewController.swift
//  NoteBook
//
//  Created by jhb15 on 12/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    var dateFormatter = DateFormatter()
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<HistoricQuery>?
    
    var filteredTableData = [HistoricQuery]()
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<HistoricQuery>(entityName: "HistoricQuery")
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        performFetchForController()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = fetchedResultsController!.fetchedObjects?.count ?? 0
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let query = fetchedResultsController?.object(at: indexPath)
        
        if isFiltered(query: query) {
            return getSearchFilteredCell(query: query, indexPath: indexPath)
        }
        
        return getSearchCell(query: query, indexPath: indexPath)
    }
    
    func isFiltered(query: HistoricQuery?) -> Bool {
        if query?.dateTo == nil && query?.dateFrom == nil && query?.orderBy == nil && query?.showFields == nil {
            return false
        }
        return true
    }
    
    func getSearchCell(query: HistoricQuery?, indexPath: IndexPath) -> SearchHistoryTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath) as! SearchHistoryTableViewCell
        
        if let q = query?.query { cell.searchTextLabel?.text = "Search Text: " + q }
        if let sd = query?.created_at { cell.searchDateLabel.text = "Search Date: " + dateFormatter.string(from: sd) }
        
        return cell
    }
    
    func getSearchFilteredCell(query: HistoricQuery?, indexPath: IndexPath) -> SearchHistoryFilteredTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueryWithFiltersCell", for: indexPath) as! SearchHistoryFilteredTableViewCell
        
        if let q = query?.query { cell.searchQueryLabel?.text = "Search Text: " + q }
        if let df = query?.dateFrom { cell.dateFromLabel?.text = "Date Form: " + dateFormatter.string(from: df) }
        if let dt = query?.dateTo { cell.dateToLabel?.text = "Date To: " + dateFormatter.string(from: dt) }
        if let ob = query?.orderBy { cell.orderLabel?.text = "Order By: " + ob }
        if let sf = query?.showFields { cell.showFeildsLabel.text = "Show Fields: " + sf.joined(separator: ", ") }
        if let sd = query?.created_at { cell.searchDateLabel.text = "Search Date: " + dateFormatter.string(from: sd) }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RedoSearch", sender: self)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if let view = segue.destination as? QueryResultsTableController,
            let indexPath = tableView.indexPathForSelectedRow,
            let query = fetchedResultsController?.object(at: indexPath) {
            view.searchText = query.query
            if isFiltered(query: query) {
                view.filters = rebuildFilters(query: query)
            }
        }
    }
    
    func rebuildFilters(query: HistoricQuery) -> GuardianContentFilters {
        let filters = GuardianContentFilters()
        filters.fromDate = query.dateFrom
        filters.toDate = query.dateTo
        if let order = query.orderBy { filters.orderBy = GuardianContentOrderFilter(rawValue: order)}
        if let sFields = query.showFields {
            filters.showFields = []
            for str in sFields {
                filters.showFields!.append(GuardianContentShowFields(rawValue: str)!)
            }
        }
        return filters
    }

}
