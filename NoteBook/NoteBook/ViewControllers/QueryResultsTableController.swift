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
        
        queryAPI()
        
        if resultsIn != nil {
            saveSearch()
        }
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
        historyRecord.dateFrom = filters?.fromDate
        historyRecord.dateTo = filters?.toDate
        //historyRecord.orderBy = filters?.orderBy
        //historyRecord.showFields = filters?.showFields
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let total = resultsIn?.response.total {
            if resultsIn!.response.total > 25 {
                return 25
            }
            return total
        }
        return resultsIn?.response.total ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableCell
        
        if resultsIn != nil && resultsIn!.response.results != nil && resultsIn!.response.results![indexPath.row].fields != nil {
            if let fields = resultsIn!.response.results![indexPath.row].fields {
                /*if let img = fields.thumbnail {
                    do {
                        try cell.imgView.image = UIImage(data: Data(contentsOf: img))
                    } catch let error as NSError {
                        print("Error trying to show thumnail. \(error)")
                    }
                }*/
                
                if let hl = fields.headline { cell.headlineLabel.text = hl }
                if let by = fields.byline { cell.bylineLabel.text = "By: " + by }
                if let cnt = fields.wordcount { cell.wordCountLabel.text = "Word Count: \(cnt)" }
            }
        }
        
        return cell
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
        
        if let view = segue.destination as? ResultDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow,
            let results = resultsIn!.response.results {
            
            view.result = results[indexPath.row]
            
        }
        
    }

}
