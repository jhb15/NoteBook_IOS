//
//  QueryResultsTableController.swift
//  NoteBook
//
//  Created by jhb15 on 10/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class QueryResultsTableController: UITableViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var offlineDataLabel: UILabel!
    @IBOutlet weak var previousPageBtn: UIButton!
    @IBOutlet weak var nextPageBtn: UIButton!
    
    var managedContext: NSManagedObjectContext?
    let guarApiController = GuardianContentClient(apiKey: "42573d7e-fb83-4aef-956f-2c52a9bca421", verbose: true)
    
    var searchText: String?
    var filters: GuardianContentFilters?
    var isFiltered: Bool = false
    
    var resultsIn : GuardianOpenPlatformData?
    var resultFromCache: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
       
        tableView.refreshControl = refreshControl
        
        queryAPI()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        guarApiController.cacheEnabled = false
        
        queryAPI()
        
        guarApiController.cacheEnabled = true
        refreshControl.endRefreshing()
    }
    
    // MARK: - UI Functions
    
    func updateTableHeader() {
        if resultsIn != nil {
            let response = resultsIn!.response
            
            
            infoLabel.text = "Page \(response.currentPage ?? 0) of \(response.pages ?? 0) \n"
                + "\(response.total) stories in total" //Maybe add items per page
            
            if resultFromCache {
                offlineDataLabel.isHidden = false
            } else {
                offlineDataLabel.isHidden = true
            }
            
            
            previousPageBtn.isEnabled = true
            nextPageBtn.isEnabled = true
            if response.currentPage == response.pages {
                nextPageBtn.isEnabled = false
            }
            if response.currentPage == 1 {
                previousPageBtn.isEnabled = false
            }
            return
        }
        infoLabel.text = "Unexpected Error"
        previousPageBtn.isEnabled = false
        nextPageBtn.isEnabled = false
    }
    
    
    // MARK: - Page Change Actions
    
    @IBAction func previousPage(_ sender: Any) {
        filters?.page = (resultsIn?.response.currentPage)! - 1
        resultsIn = nil
        queryAPI()
    }
    
    @IBAction func nextPage(_ sender: Any) {
        filters?.page = (resultsIn?.response.currentPage)! + 1
        resultsIn = nil
        queryAPI()
    }
    
    // MARK: - API Query Functions
    
    /**
     Function for quering the API.
     */
    func queryAPI() {
        do {
            try guarApiController.searchContent(for: searchText ?? "", usingFilters: filters, withCallback: {
                (data:GuardianOpenPlatformData?, fromCache: Bool) in
                if data != nil {
                    self.resultsIn = data
                    self.resultFromCache = fromCache
                } else {
                    print("Error no Data passed back from 'GuardianContentClient.searchContent'")
                }
                DispatchQueue.main.async {
                    self.updateView()
                }
            })
            print("Sent Request!")
        } catch let error as NSError {
            print("Error Performing Search: \(error.localizedDescription)")
        }
        
    }
    
    func updateView() {
        updateTableHeader()
        
        tableView.reloadData()
        
        if filters != nil && filters!.page != nil && filters!.page! > 1 { //To prevent multiple record of the same query
            return
        }
        saveSearch()
    }
    
    /**
     This function is designed to check the HistoricQuery CoreData entity for an existing query with the same perameters. If
     one is found it will be returned.
     */
    func queryExists() -> HistoricQuery? {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoricQuery")
        fetchReq.returnsDistinctResults = true
        
        
        let qPredicate = NSPredicate(format: "query == %@", searchText!)
        var dfPredicate = NSPredicate(format: "dateFrom == %@",  0)
        var dtPredicate = NSPredicate(format: "dateTo == %@", 0)
        var obPredicate = NSPredicate(format: "orderBy == %@",0)
        var sfPredicate = NSPredicate(format: "showFields == %@", 0) //0 should mean nil/null
        
        if isFiltered && filters != nil {
            
            let toDate = (filters!.toDate)! as NSDate; let fromDate = (filters!.fromDate)! as NSDate
            dfPredicate = NSPredicate(format: "dateFrom == %@",  fromDate)
            dtPredicate = NSPredicate(format: "dateTo == %@", toDate)
            obPredicate = NSPredicate(format: "orderBy == %@", filters!.orderBy!.rawValue as NSString)
            
            var sfs: [String] = []
            if let showFields = filters!.showFields {
                for field in showFields {
                    sfs.append(field.rawValue)
                }
                sfPredicate = NSPredicate(format: "showFields == %@", sfs as [NSString])
            }
        }
        
        let pred = NSCompoundPredicate(type: .and, subpredicates: [qPredicate, obPredicate, dfPredicate, dtPredicate, sfPredicate])
        fetchReq.predicate = pred
        
        do {
            let result = try managedContext?.fetch(fetchReq) as? [HistoricQuery]
            if (result?.count)! > 0 {
                return result?[0]
            }
        } catch let error as NSError {
            print("Error checking for existing query. Dscr: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    /**
     This function will either update the created_at attribute of an existing query or add the new query to the history
     of searches.
     */
    func saveSearch() {
        if let query = queryExists() {
            query.created_at = Date()
        } else {
            let historyRecord = HistoricQuery(entity: HistoricQuery.entity(), insertInto: managedContext)
            historyRecord.query = searchText
            if let filt = filters {
                historyRecord.dateFrom = filt.fromDate
                historyRecord.dateTo = filt.toDate
                historyRecord.orderBy = filt.orderBy?.rawValue
                
                if let fields = filt.showFields {
                    var showFields: [String] = []
                    for str in fields {
                        showFields.append(str.rawValue)
                    }
                    historyRecord.showFields = showFields
                }
            }
            historyRecord.created_at = Date()
        }
        
        do {
            try managedContext?.save()
            print("Added to Search History")
        } catch let error as NSError {
            print("error with \(error)")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if resultsIn != nil {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        }
        let noDataLabel = UILabel()
        noDataLabel.text = "Guardian API Returned No Data! This could be because there where no results to show, the page you specified was out of range or a unknown error!"
        noDataLabel.textColor = UIColor.gray
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 5
        tableView.separatorStyle = .none
        tableView.backgroundView = noDataLabel
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let total = resultsIn!.response.total
        
        if let pages = resultsIn!.response.pages,
            let pageSize = resultsIn!.response.pageSize,
            let currentPage = resultsIn!.response.currentPage {
            if pages > 1 {
                if currentPage != pages {
                    return pageSize
                }
                return total % pageSize
            } else {
                return total
            }
        }
        return total
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let result = resultsIn!.response.results?[indexPath.row] {
            cell.webTitleLabel.text = result.webTitle
            cell.categoryLabel.text = "Category: " + (result.sectionName ?? "Unknown")
            if let date = result.webPublicationDate{ cell.publishedLabel.text = "Published " + dateFormatter.string(from: date) }
            
            if let fields = result.fields {
                    if let cnt = fields.wordcount { cell.wordCountLabel.text = "Word Count: \(cnt)" }
            } else {
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let result = resultsIn!.response.results?[indexPath.row],
            let _ = result.fields {
            performSegue(withIdentifier: "ShowDetail", sender: self)
        } else {
            performSegue(withIdentifier: "AddLink", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let indexPath = tableView.indexPathForSelectedRow,
            let results = resultsIn!.response.results {
            
            if let view = segue.destination as? ResultDetailViewController {
                view.result = results[indexPath.row]
            }
            
            if let view = segue.destination as? SelectNoteTableViewController {
                view.article = results[indexPath.row]
            }
        }
    }

}
