//
//  SearchHistoryFilteredTableViewCell.swift
//  NoteBook
//
//  Created by jhb15 on 12/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchTextLabel: UILabel!
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
