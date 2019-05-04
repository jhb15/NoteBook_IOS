//
//  GuardianQueryViewController.swift
//  NoteBook
//
//  Created by admin on 04/05/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class GuardianQueryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var addFiltersBtn: UIButton!
    @IBOutlet weak var filtersTableView: UITableView!
    
    let reuseIDd = ["filterCell", "datePickerCell", "pickerCell"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersTableView.dataSource = self
        filtersTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFiltersAction(_ sender: Any) {
        
    }
    
    @IBAction func executeSearchAction(_ sender: Any) {
        
    }
    
    @IBAction func historyAction(_ sender: Any) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reuseIDd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIDd[indexPath.row], for: indexPath)
        
        
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
