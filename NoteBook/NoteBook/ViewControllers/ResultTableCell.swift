//
//  ResultTableCell.swift
//  NoteBook
//
//  Created by jhb15 on 10/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
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
