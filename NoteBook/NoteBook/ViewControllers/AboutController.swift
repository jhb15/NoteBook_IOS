//
//  AboutController.swift
//  NoteBook
//
//  Created by (Student Number: 140159095) on 02/04/2019.
//  Copyright © 2019 Aberystwyth Univerity. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet weak var content: UITextView!
    
    var introductionParagraph = "This is tehe app that I developed as the solution to the SEM2220 Native Application Assignmet."
    
    var attributions: [String: String] = ["The Application Icon": "To generate the Icon I used this site: https://romannurik.github.io/AndroidAssetStudio \n"
                                               + "And then used https://appiconmaker.co/Home/Index to convert it into an iOS icon sizes.",
                                          "The Tab Bar Icons": "Icon part of the package downloaded from the icons8 site. (https://icons8.com/ios)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.text = introductionParagraph
        
        content.text += "\n\n\n\n\n"
        
        content.text += "Credits: \n"
        
        for item in attributions {
            content.text += "\n[" + item.key + "]: \n" + item.value + "\n"
        }
    }

}
