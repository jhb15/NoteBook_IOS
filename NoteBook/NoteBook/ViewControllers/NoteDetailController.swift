//
//  NoteDetailController.swift
//  NoteBook
//
//  Created by jhb15 on 06/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit

class NoteDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var contentTextArea: UITextView!
    @IBOutlet weak var linksTable: UITableView!
    
    var noteItem: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        linksTable.delegate = self; linksTable.dataSource = self

        titleLabel.text = noteItem?.title
        var times = ""
        if let cre = noteItem?.created_at,
            let upd = noteItem?.updated_at {
            times = "Created: " + dateFormatter.string(from: cre) + " Updated: " + dateFormatter.string(from: upd)
        } else {
            times = "Created: err Updated: err"
        }
        timestampLabel.text = times
        contentTextArea.text = noteItem?.content
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        linksTable.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let view = segue.destination as? WebViewController,
            let indexPath = linksTable.indexPathForSelectedRow {
            if let link = noteItem!.links?.object(at: indexPath.row) as? Link {
                view.link = link
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let links = noteItem!.links {
            return links.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let links = noteItem!.links
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
        
        let link = links?.object(at: indexPath.row) as! Link
        cell.textLabel?.text = link.title
        
        return cell
    }

}
