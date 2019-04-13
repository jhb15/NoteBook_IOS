//
//  ResultDetailViewController.swift
//  NoteBook
//
//  Created by jhb15 on 10/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import WebKit

class ResultDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var lastModLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var result: GuardianOpenPlatformResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        //bodyTextView.isEditable = false
        
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
                let str = dateFormatter.string(from: lastMod)
                lastModLabel.text = "Last Modified: " + str
            }
            
            if let trail = fields.trailText,
                let body = fields.body {
                let html = "<b>" + trail + "</b>" + body
                webView.loadHTMLString(html, baseURL: nil) // Not Sure WebView is the best option but is okay for now
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let view = segue.destination as? SelectNoteTableViewController {
            view.article = result
        }
    }

}
