//
//  GuardianQueryController.swift
//  NoteBook
//
//  Created by jhb15 on 08/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class GuardianQueryController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    //Labels
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var orderByLabel: UILabel!
    @IBOutlet weak var showFieldLabel: UILabel!
    
    //Value Selectors
    @IBOutlet weak var serchText: UITextField!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var orderByPicker: UIPickerView!
    @IBOutlet weak var showFieldSelector: UITableView!
    
    let dateFormatter = DateFormatter()
    
    var fromDate: Date?
    var toDate: Date?
    var orderBy: String?
    var showFields: [String]?
    
    var orderOptions = ["newest", "oldest", "relevance"]
    var showFieldOptions = ["trailText", "headline", "body", "lastModified"] //TODO may need more fields?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = NSLocale.current

        toDatePicker.datePickerMode = .date; fromDatePicker.datePickerMode = .date
        toDatePicker.locale = NSLocale.current; fromDatePicker.locale = NSLocale.current
        toDatePicker.maximumDate = Date(); fromDatePicker.maximumDate = Date()
        
        toDatePicker.addTarget(self, action: #selector(toDateChanged(_:)), for: .valueChanged)
        fromDatePicker.addTarget(self, action: #selector(fromDateChanged(_:)), for: .valueChanged)
        
        orderByPicker.delegate = self; orderByPicker.dataSource = self
        
        showFieldSelector.delegate = self; showFieldSelector.dataSource = self
        
    }
    
    @IBAction func searchGuardianAPI(_ sender: Any) {
        var queryObj: QueryObject
        if validateForm() {
            //Should be okay to force this as I have done the previous validation check in the if statement
            queryObj = QueryObject(queryText: serchText.text!, dateFrom: fromDate!, dateTo: toDate!,
                                   orderBy: orderBy!, showFields: showFields!)
            print(queryObj.toString())
        } else {
            print("Invalid Input")
        }
    }
    
    func validateForm() -> Bool {
        
        var vQuery = false
        let vDate = dateValid()
        var vOrder = false
        var vShowFields = false
        
        if serchText.text != nil {
            vQuery = true
        }
        
        if orderBy != nil {
            vOrder = true
        }
        
        if showFields != nil {
            vShowFields = true
        }
        
        if vQuery && vDate && vOrder && vShowFields {
            return true
        } else {
            return false
        }
    }
    
    func dateValid() -> Bool {
        if let to = toDate, let from = fromDate {
            switch (from.compare(to)) {
            case .orderedAscending:
                return true;
            case .orderedDescending:
                return false;
            case .orderedSame:
                return false;
            }
        }
        return false;
    }
    
    @objc func fromDateChanged(_ sender: UIDatePicker) {
        fromDate = sender.date
        fromDateLabel.text = "Date From: " + dateFormatter.string(from: sender.date)
    }
    
    @objc func toDateChanged(_ sender: UIDatePicker) {
        toDate = sender.date
        toDateLabel.text = "Date To: " + dateFormatter.string(from: sender.date)
    }
    
    func showFieldsUpdate() {
        let cells = showFieldSelector.visibleCells
        var options = [String]()
        
        for cell in cells {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                if let option = cell.textLabel?.text {
                    options.append(option)
                }
            }
        }
        
        showFields = options
        if let fields = showFields {
            showFieldLabel.text = "Show Fields: " + listStringArray(strings: fields)
        }
    }
    
    func listStringArray(strings: [String]) -> String {
        var out = ""
        for s in strings {
            out += " " + s + ","
        }
        return out
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orderOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return orderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        orderBy = orderOptions[row]
        orderByLabel.text = "Order By: " + orderOptions[row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showFieldOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        
        cell.textLabel?.text = showFieldOptions[indexPath.row]
        cell.accessoryType = UITableViewCell.AccessoryType.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        showFieldsUpdate()
    }
}
