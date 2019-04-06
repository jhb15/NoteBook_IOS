//
//  NoteDetailController.swift
//  NoteBook
//
//  Created by jhb15 on 06/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class NoteDetailController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextArea: UITextView!
    
    var noteItem: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = noteItem?.title
        contentTextArea.text = noteItem?.content
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
