//
//  SearchHistoryTableViewCell.swift
//  NoteBook
//
//  Created by (Student Number: 140159095) on 12/04/2019.
//  Copyright © 2019 Aberystwyth Univerity. All rights reserved.
//

import UIKit

class SearchHistoryFilteredTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchQueryLabel: UILabel!
    @IBOutlet weak var pageInfoLabel: UILabel!
    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var dateUsing: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var showFeildsLabel: UILabel!
    @IBOutlet weak var searchDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
