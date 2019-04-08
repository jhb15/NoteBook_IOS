//
//  PickerCell.swift
//  NoteBook
//
//  Created by jhb15 on 08/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {
    
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //picker.dataSource
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
