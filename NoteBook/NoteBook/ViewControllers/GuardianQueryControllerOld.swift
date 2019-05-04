//
//  GuardianQueryController.swift
//  NoteBook
//
//  Created by (Student Number: 140159095) on 08/04/2019.
//  Copyright © 2019 Aberystwyth Univerity. All rights reserved.
//

import UIKit

class GuardianQueryControllerOld: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    //Content
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addFiltersBtn: UIButton!
    
    //Labels
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var useDateLabel: UILabel!
    @IBOutlet weak var orderByLabel: UILabel!
    @IBOutlet weak var showFieldLabel: UILabel!
    
    //Value Selectors
    @IBOutlet weak var serchText: UITextField!
    @IBOutlet weak var pageNumberTextField: UITextField!
    @IBOutlet weak var resultsPerTextField: UITextField!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var orderByPicker: UIPickerView!
    @IBOutlet weak var showFieldSelector: UITableView!
    
    //Global Vars
    let dateFormatter = DateFormatter()
    let dateUsingOptions = GuardianContentDateFilter.allCases
    var orderByOptions = GuardianContentOrderFilter.allCases
    var orderUsingOptions = GuardianContentOrderDateFilter.allCases
    var showFieldOptions = GuardianContentShowFields.allCases
    var isFieldSelected = [Bool](repeating: false, count: GuardianContentShowFields.allCases.count) //TODO MASSIVE BODGE
    
    //Global Value Holders
    var pageNum: Int?
    var pageSize: Int?
    var fromDate: Date?
    var toDate: Date?
    var toFromUsing: GuardianContentDateFilter?
    var orderBy: GuardianContentOrderFilter?
    var orderUsing: GuardianContentOrderDateFilter?
    var filters: GuardianContentFilters?
    var showFields: [GuardianContentShowFields]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isHidden = true
        
        pageNumberTextField.text = "\(DEFAULT_PAGE)"
        resultsPerTextField.text = "\(DEFAULT_PAGE_SIZE)"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = NSLocale.current

        toDatePicker.datePickerMode = .date; fromDatePicker.datePickerMode = .date
        toDatePicker.locale = NSLocale.current; fromDatePicker.locale = NSLocale.current
        toDatePicker.maximumDate = Date(); fromDatePicker.maximumDate = Date(); dateUsingChanged(val: dateUsingOptions[0])
        
        toDatePicker.addTarget(self, action: #selector(toDateChanged(_:)), for: .valueChanged)
        fromDatePicker.addTarget(self, action: #selector(fromDateChanged(_:)), for: .valueChanged)
        toDateChanged(toDatePicker); fromDateChanged(fromDatePicker); orderByChanged()
        
        orderByPicker.delegate = self; orderByPicker.dataSource = self
        
        showFieldSelector.delegate = self; showFieldSelector.dataSource = self
        
    }
    
    /**
     Action function for when the add filters button is toggled.
     */
    @IBAction func toggleFilters(_ sender: Any) {
        if scrollView.isHidden {
            scrollView.isHidden = false
            addFiltersBtn.setTitle("Remove Filters", for: .normal)
        } else {
            scrollView.isHidden = true
            addFiltersBtn.setTitle("Add Filters", for: .normal)
        }
    }
    
    /**
     Function that is used to perform the action of specifying the use-date filter for date from and date to.
     */
    @IBAction func setDateUsing(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Using Date", message: "The data used by the date to and date from filters.", preferredStyle: .actionSheet)
        
        for option in dateUsingOptions {
            let btn = UIAlertAction(title: option.rawValue, style: .default, handler: { (bock) in
                DispatchQueue.main.async {
                    self.toFromUsing = option
                    self.dateUsingChanged(val: option)
                }
            })
            actionSheet.addAction(btn)
        }
        let btn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(btn)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    /**
     This function is used to initiate a search request on the guardian API.
     */
    @IBAction func searchGuardianAPI(_ sender: Any) {
        var errorMsgs: [String] = []
        if validateForm(err: &errorMsgs) {
            filters = GuardianContentFilters()
            
            if !scrollView.isHidden {
                
                filters!.page = Int(pageNum ?? DEFAULT_PAGE)
                filters!.pageSize = Int(pageSize ?? DEFAULT_PAGE_SIZE)
                filters!.fromDate = fromDate
                filters!.toDate = toDate
                filters!.useDate = toFromUsing
                filters!.orderBy = orderBy
                filters!.orderDate = orderUsing
                
                if showFields != nil {
                    filters!.showFields = showFields
                }
            }
            //TODO Display Result
            performSegue(withIdentifier: "ShowResults", sender: nil)
            
        } else {
            print("Invalid Input, Stopping Request")
            alertUser(title: "InValid Input", message: errorMsgs.joined(separator: "\n\n"))
        }
    }
    
    /**
     Function for validateing the input, only fields that really need validateing are the page number and page size
     fields as they have direct user input.
     */
    func validateForm(err: inout [String]) -> Bool {
        
        var valid = true
        
        if let pageNum = Int(pageNumberTextField.text!),
            pageNum > 0 {
            self.pageNum = pageNum
        } else {
            //alertUser(title: "Invalid Page Numer!", message: "Page numer must be an interger value abouve 0.")
            err.append("[Ivalid Page Number!]\nPage numer must be an interger value abouve 0.")
            self.pageNum = nil
            pageNumberTextField.text = "\(DEFAULT_PAGE)"
            valid = false
        }
        
        if let pageSize = Int(resultsPerTextField.text!),
            pageSize >= MIN_PAGE_SIZE && pageSize <= MAX_PAGE_SIZE {
            self.pageSize = pageSize
        } else {
            //alertUser(title: "Invalid Page Size!", message: "Page size must be between \(MIN_PAGE_SIZE) and \(MAX_PAGE_SIZE)")
            err.append("[Invalid Page Size!]\nPage size must be between \(MIN_PAGE_SIZE) and \(MAX_PAGE_SIZE).")
            self.pageSize = nil
            self.resultsPerTextField.text = "\(DEFAULT_PAGE_SIZE)"
            valid = false
        }

        return valid
    }
    
    /**
     Function that is triggered when the from date has been changed on the date picker.
     */
    @objc func fromDateChanged(_ sender: UIDatePicker) {
        if let date = sanitizeDate(date: sender.date) {
            fromDate = date
            fromDateLabel.text = "Date From: " + dateFormatter.string(from: date)
            toDatePicker.minimumDate = date
        }
    }
    
    /**
     Function that is triggered when the to date has been changed on the date picker.
     */
    @objc func toDateChanged(_ sender: UIDatePicker) {
        if let date = sanitizeDate(date: sender.date) {
            toDate = date
            toDateLabel.text = "Date To: " + dateFormatter.string(from: date)
            fromDatePicker.maximumDate = date
        }
    }
    
    /**
     Function for setting the time of a date field to a default value. Couldn't find a better way of doing
     this wierdly. Its needed to stop duplicte history records when the difference is just the time in the
     Date object.
     //TODO probably could be improved -- not sure how
     */
    func sanitizeDate(date: Date) -> Date? {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let dateStr = "\(day)/\(month)/\(year) 00:00:00"
        
        dateFormatter.dateFormat = DATE_FORMAT_WITH_TIME
        let cleanDate = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = nil
        
        print(cleanDate!)
        
        return cleanDate
    }
    
    /**
     Function that is called when the date-using filter has been changed.
     */
    func dateUsingChanged(val: GuardianContentDateFilter) {
        toFromUsing = val
        useDateLabel.text = "Useing: " + val.rawValue
    }
    
    /**
     Function that is called when the order-by value has been changed on the order date picker.
     */
    func orderByChanged() {
        let orderUsing = orderUsingOptions[orderByPicker.selectedRow(inComponent: 0)]
        let orderBy = orderByOptions[orderByPicker.selectedRow(inComponent: 1)]
        self.orderBy = orderBy; self.orderUsing = orderUsing
        orderByLabel.text = "Order Using: " + orderUsing.rawValue + " By: " + orderBy.rawValue
    }
    
    /**
     Function called when there has been a chnge in the Show Field table view.
     */
    func showFieldsUpdate() {
        var options = [GuardianContentShowFields]()
        var strAry: [String] = []
        
        for (index, selected) in isFieldSelected.enumerated() {
            if selected {
                options.append(showFieldOptions[index])
                strAry.append(showFieldOptions[index].rawValue)
            }
        }
        
        showFields = options
        
        var str = "Show Fields: "
        if options.count > 0 {
            str.append("\n[" + strAry.joined(separator: ", ") + "]")
        }
        showFieldLabel.text = str
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let view = segue.destination as? QueryResultsTableController {
            view.searchText = serchText.text
            view.filters = filters
            view.isFiltered = !scrollView.isHidden
        }
    }
    
    /**
     Overrided so that when the user clicks on the view the keyboard will dissapear.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Picker View Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return orderUsingOptions.count
        }
        return orderByOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return orderUsingOptions[row].rawValue
        }
        return orderByOptions[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        orderByChanged()
    }
    
    // MARK: - Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showFieldOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! ShowFieldOptCell
        
        cell.showFieldObj = showFieldOptions[indexPath.row]
        cell.textLabel?.text = showFieldOptions[indexPath.row].rawValue
        if isFieldSelected[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if isFieldSelected[indexPath.row] {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        isFieldSelected[indexPath.row] = !isFieldSelected[indexPath.row]
        
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
