//
//  WebViewController.swift
//  NoteBook
//
//  Created by jhb15 on 10/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var link: Link?

    override func viewDidLoad() {
        super.viewDidLoad()

        if link != nil {
            let myRequest = URLRequest(url: link!.url!)
            webView.load(myRequest)
        }
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
