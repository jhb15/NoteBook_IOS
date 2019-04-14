//
//  AboutController.swift
//  NoteBook
//
//  Created by jhb15 on 02/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet weak var content: UITextView!
    
    var attributions: [String: String] = ["The Tab Bar Icons": "TODO Add attribution.",
                                          "The Application Icon": "Icon part of the package downloaded from the icons8 site. (https://icons8.com/ios)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.text += "\n\n\n\n\n"
        
        content.text += "Credits: \n"
        
        for item in attributions {
            content.text += "\n[" + item.key + "]: \n" + item.value + "\n"
        }
        
        

        // Do any additional setup after loading the view.
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
