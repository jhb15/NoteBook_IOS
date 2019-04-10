//
//  QueryResultsTableController.swift
//  NoteBook
//
//  Created by jhb15 on 10/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class QueryResultsTableController: UITableViewController {
    
    var resultsIn : GuardianOpenPlatformData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if resultsIn != nil && resultsIn!.response.results != nil {
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
