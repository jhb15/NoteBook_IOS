//
//  ResultTableCell.swift
//  NoteBook
//
//  Created by (Student Number: 140159095) on 10/04/2019.
//  Copyright © 2019 Aberystwyth Univerity. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {
    
    @IBOutlet weak var webTitleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
