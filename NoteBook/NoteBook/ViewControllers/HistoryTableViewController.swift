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
    //UI Elements
    @IBOutlet weak var clearBtn: UIButton!
    
    //Global Vars
    var dateFormatter = DateFormatter()
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<HistoricQuery>?
    
    var filteredTableData = [HistoricQuery]()
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearBtn.isEnabled = false
        dateFormatter.dateFormat = DATE_FORMAT_WITH_TIME

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
    
    @IBAction func clearHistory(_ sender: Any) {
        let alertCntrl = UIAlertController(title: "Clear History", message: "Are you sure you want to delete all of your Search History?", preferredStyle: .alert)
        
        let yesBtn = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.clearHistoryConfirm()
        })
        let noBtn = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertCntrl.addAction(yesBtn)
        alertCntrl.addAction(noBtn)
        present(alertCntrl, animated: true, completion: nil)
    }
    
    func clearHistoryConfirm() {
        let history = fetchedResultsController?.fetchedObjects
        if history != nil && history!.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoricQuery")
            
            let batchDel = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext?.execute(batchDel)
                print("Cleared History")
            } catch let error as NSError {
                print("Error Clearing History, \(error.localizedDescription)")
            }
        }
        performFetchForController()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let cnt = fetchedResultsController!.fetchedObjects?.count,
            cnt > 0 {
            clearBtn.isEnabled = true
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        }
        clearBtn.isEnabled = false
        let noDataLabel = UILabel()
        noDataLabel.text = "No History to Show"
        noDataLabel.textColor = UIColor.gray
        noDataLabel.textAlignment = .center
        tableView.separatorStyle = .none
        tableView.backgroundView = noDataLabel
        return 0
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
        if let p = query?.page, let ps = query?.pageSize { cell.pageInfoLabel.text = "Page: \(p) Page Size: \(ps)"}
        dateFormatter.dateFormat = DATE_FORMAT_NO_TIME
        if let df = query?.dateFrom { cell.dateFromLabel?.text = "Date Form: " + dateFormatter.string(from: df) }
        if let dt = query?.dateTo { cell.dateToLabel?.text = "Date To: " + dateFormatter.string(from: dt) }
        dateFormatter.dateFormat = DATE_FORMAT_WITH_TIME
        if let ud = query?.useDate { cell.dateUsing?.text = "Date Using " + ud }
        if let ob = query?.orderBy { cell.orderLabel?.text = "Order By: " + ob }
        if let od = query?.orderDate { cell.orderDate?.text = "Order Using: " + od }
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
                view.isFiltered = true
            } else {
                view.isFiltered = false
            }
        }
    }
    
    func rebuildFilters(query: HistoricQuery) -> GuardianContentFilters {
        let filters = GuardianContentFilters()
        
        if query.page > 0 { filters.page = Int(query.page) }
        if query.pageSize >= MIN_PAGE_SIZE && query.pageSize <= MAX_PAGE_SIZE { filters.pageSize = Int(query.pageSize) }
        
        filters.fromDate = query.dateFrom
        filters.toDate = query.dateTo
        if let order = query.orderBy { filters.orderBy = GuardianContentOrderFilter(rawValue: order)}
        if let orderDate = query.orderDate { filters.orderDate = GuardianContentOrderDateFilter(rawValue: orderDate)}
        if let useDate = query.useDate { filters.useDate = GuardianContentDateFilter(rawValue: useDate)}
        if let sFields = query.showFields {
            filters.showFields = []
            for str in sFields {
                filters.showFields!.append(GuardianContentShowFields(rawValue: str)!)
            }
        }
        return filters
    }
}
