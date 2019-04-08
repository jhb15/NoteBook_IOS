//
//  GuardianQueryFormController.swift
//  NoteBook
//
//  Created by jhb15 on 07/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

enum FieldType:String {
    case SerchTextCell
    case DateCell
    case ListOptionsCell
    case MultipleChoice
}
struct FieldData {
    var opened = Bool()
    var id = String()
    var title = String()
    var type: FieldType
    var sectionData = [String]()
}

class GuardianQueryFormController: UITableViewController {
    
    var tableViewCells = [FieldData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewCells = [FieldData(opened: false, id: "q", title: "Search Text...", type: FieldType.SerchTextCell, sectionData: []),
                          FieldData(opened: false, id: "dateFrom", title: "From: ", type: FieldType.DateCell, sectionData: []),
                          FieldData(opened: false, id: "dateTo", title: "To: ", type: FieldType.DateCell, sectionData: []),
                          FieldData(opened: false, id: "orderBy", title: "Order By:", type: FieldType.ListOptionsCell, sectionData: ["newest", "pldest", "relevance"]),
                          FieldData(opened: false, id: "showFields", title: "Show Fields: ", type: FieldType.MultipleChoice, sectionData: ["trailText", "headline", "body", "lastModified", "score", "byline", "starRating", "all"])]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = tableViewCells[indexPath.row]
        let identifier = field.type
        
        if identifier == FieldType.SerchTextCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath) as? SearchTextCell {
            
                return cell
            }
        }
        
        if identifier == FieldType.DateCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath) as? DatePickerCell {
                cell.cellLabel.text = field.title
                return cell
            }
        }

        if identifier == FieldType.ListOptionsCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath) as? PickerCell {
                cell.cellLabel.text = field.title
                return cell
            }
        }
            
        if identifier == FieldType.MultipleChoice {
            //Add multiple choice
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath)
    }
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var field = tableViewCells[indexPath.row]
        
        if field.type == FieldType.DateCell {
            if let cell = tableView.cellForRow(at: indexPath) as? DatePickerCell {
                field.opened = !field.opened
                cell.datePicker.isHidden = !cell.datePicker.isHidden
                tableView.beginUpdates()
                
                tableView.endUpdates()
            }
        }
    }*/

    /*override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let fieldType = tableViewCells[indexPath.row].type
        
        if fieldType == FieldType.DateCell {
            if let cell = tableView.cellForRow(at: indexPath) as? DatePickerCell {
                cell.datePicker.isHidden = true
                tableView.reloadData()
            }
        }
        
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
