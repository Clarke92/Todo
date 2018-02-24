//
//  ViewController.swift
//  Todo iOS 11
//
//  Created by Maximilian Dufter on 24.02.18.
//  Copyright © 2018 Maximilian Dufter. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    let itemArray = ["Finish Show", "Buy Netflix Month", "Download Movie"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK - Tableview Datasour Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
}

