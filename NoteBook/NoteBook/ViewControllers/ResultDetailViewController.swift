//
//  ResultDetailViewController.swift
//  NoteBook
//
//  Created by jhb15 on 10/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class ResultDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var lastModLabel: UILabel!
    @IBOutlet weak var trailTextLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var result: GuardianOpenPlatformResult?
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = NSLocale.current
        bodyTextView.isEditable = false
        
        if let fields = result?.fields {
            if let img = fields.thumbnail {
                do {
                    try imgView.image = UIImage(data: Data(contentsOf: img))
                } catch let error as NSError {
                    print("Error trying to show thumnail. \(error)")
                }
            }
            
            if let headline = fields.headline { headlineLabel.text = headline }
            
            if let byline = fields.byline {
                let str = "By: " + byline
                bylineLabel.text = str
            }
            
            if let lastMod = fields.lastModified {
                lastModLabel.text = "Last Modified: " + dateFormatter.string(from: lastMod)
            }
            
            if let trail = fields.trailText { trailTextLabel.text = trail }
            
            if let body = fields.body { bodyTextView.text = body }
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
