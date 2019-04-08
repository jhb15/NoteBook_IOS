//
//  DatePickerCell.swift
//  NoteBook
//
//  Created by jhb15 on 08/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        datePicker.addTarget(self, action: #selector(DatePickerCell.datePickerValueChanged(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        selectedDate = sender.date
    }

}
