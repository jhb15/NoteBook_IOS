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
    
    @IBOutlet weak var pageNumberLab: UILabel!
    @IBOutlet weak var numberOfPages: UILabel!
    @IBOutlet weak var resultsPerPage: UILabel!
    @IBOutlet weak var totalResults: UILabel!
    
    var managedContext: NSManagedObjectContext?
    let guarApiController = GuardianContentClient(apiKey: "42573d7e-fb83-4aef-956f-2c52a9bca421", verbose: true)
    
    var searchText: String?
    var filters: GuardianContentFilters?
    
    var resultsIn : GuardianOpenPlatformData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
            
        }
        managedContext = delegate.persistentContainer.viewContext
        
        queryAPI() //Neeed to add cacheing
        
        saveSearch() //Need This in More Appropriate Place
    }
    
    /**
     Function for quering the API.
     */
    func queryAPI() {
        do {
            try guarApiController.searchContent(for: searchText ?? "", usingFilters: filters, withCallback: {
                (data:GuardianOpenPlatformData?) in
                if data != nil {
                    self.resultsIn = data
                } else {
                    print("Error no Data passed back from 'GuardianContentClient.searchContent'")
                }
            })
            print("Sent Request!")
        } catch let error as NSError {
            print("Error Performing Search: \(error.localizedDescription)")
        }
        
        while resultsIn == nil {
            usleep(2000)
        }
        
        if resultsIn != nil && resultsIn!.response.results != nil {
            pageNumberLab.text = "Page \(resultsIn!.response.currentPage ?? 0)"
            numberOfPages.text = "\(resultsIn!.response.pages ?? 0) pages"
            resultsPerPage.text = "25 stories per page"
            totalResults.text = "\(resultsIn!.response.total) stories in total"
        }
        tableView.reloadData()
    }
    
    func saveSearch() {
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
        
        do {
            try managedContext?.save()
            print("Added to Search History")
        } catch let error as NSError {
            print("error with \(error)")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
