//
//  GuardianQueryController.swift
//  NoteBook
//
//  Created by jhb15 on 08/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class GuardianQueryController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    //Content
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addFiltersBtn: UIButton!
    
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
    
    //Global Vars
    let dateFormatter = DateFormatter()
    var orderOptions = GuardianContentOrderFilter.allCases
    //var showFieldOptions = ["trailText", "headline", "body", "lastModified"] //TODO may need more fields?
    var showFieldOptions = GuardianContentShowFields.allCases
    
    //Global Value Holders
    var fromDate: Date?
    var toDate: Date?
    var orderBy: GuardianContentOrderFilter?
    var showFields: [GuardianContentShowFields]?
    
    var filters: GuardianContentFilters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isHidden = true
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = NSLocale.current

        toDatePicker.datePickerMode = .date; fromDatePicker.datePickerMode = .date
        toDatePicker.locale = NSLocale.current; fromDatePicker.locale = NSLocale.current
        toDatePicker.maximumDate = Date(); fromDatePicker.maximumDate = Date()
        
        toDatePicker.addTarget(self, action: #selector(toDateChanged(_:)), for: .valueChanged)
        fromDatePicker.addTarget(self, action: #selector(fromDateChanged(_:)), for: .valueChanged)
        toDateChanged(toDatePicker); fromDateChanged(fromDatePicker); orderByChanged(row: orderByPicker.selectedRow(inComponent: 1))
        
        orderByPicker.delegate = self; orderByPicker.dataSource = self
        
        
        showFieldSelector.delegate = self; showFieldSelector.dataSource = self
        
    }
    
    @IBAction func toggleFilters(_ sender: Any) {
        if scrollView.isHidden {
            scrollView.isHidden = false
            addFiltersBtn.setTitle("Remove Filters", for: .normal)
        } else {
            scrollView.isHidden = true
            addFiltersBtn.setTitle("Add Filters", for: .normal)
        }
    }
    
    @IBAction func searchGuardianAPI(_ sender: Any) {
        if validateForm() {
            if !scrollView.isHidden {
                filters = GuardianContentFilters()
                
                filters!.page = 1
                filters!.pageSize = 25
                filters!.fromDate = fromDate
                filters!.toDate = toDate
                filters!.orderBy = orderBy
                
                if showFields != nil {
                    filters!.showFields = showFields
                }
            } else {
                filters = nil
            }
            //TODO Display Result
            performSegue(withIdentifier: "ShowResults", sender: nil)
            
        } else {
            print("Invalid Input") //TODO More Detailed Validation Error Messages Needed
            alertUser(title: "InValid Input", message: "You have entered the incorrect input. More Detailed messages soon!")
        }
    }
    
    //Nolonger needed!
    func validateForm() -> Bool {
        
        let vDate = true
        var vOrder = false
        
        if orderBy != nil {
            vOrder = true
        }
        
        if vDate && vOrder {
            return true
        } else {
            return false
        }
    }
    
    @objc func fromDateChanged(_ sender: UIDatePicker) {
        fromDate = sender.date
        fromDateLabel.text = "Date From: " + dateFormatter.string(from: sender.date)
        toDatePicker.minimumDate = sender.date
    }
    
    @objc func toDateChanged(_ sender: UIDatePicker) {
        toDate = sender.date
        toDateLabel.text = "Date To: " + dateFormatter.string(from: sender.date)
        fromDatePicker.maximumDate = sender.date
    }
    
    func orderByChanged(row: Int) {
        orderBy = orderOptions[row]
        orderByLabel.text = "Order By: " + orderOptions[row].rawValue
    }
    
    func showFieldsUpdate() {
        let cells = showFieldSelector.visibleCells as! [ShowFieldOptCell]
        var options = [GuardianContentShowFields]()
        
        for cell in cells {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                if let option = cell.showFieldObj {
                    options.append(option)
                }
            }
        }
        
        showFields = options
        /*if let fields = showFields {
            showFieldLabel.text = "Show Fields: " + listStringArray(strings: fields)
        }*/ //NOTE This part may not be needed.
    }
    
    func listStringArray(strings: [String]) -> String {
        var out = ""
        for s in strings {
            out += " " + s + ","
        }
        return out
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let view = segue.destination as? QueryResultsTableController {
            view.searchText = serchText.text
            view.filters = filters
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orderOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return orderOptions[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        orderByChanged(row: row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showFieldOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! ShowFieldOptCell
        
        cell.showFieldObj = showFieldOptions[indexPath.row]
        cell.textLabel?.text = showFieldOptions[indexPath.row].rawValue
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
    
    func alertUser(title: String, message: String) {
        let alertCntrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertCntrl.addAction(okBtn)
        present(alertCntrl, animated: true, completion: nil)
    }
}
