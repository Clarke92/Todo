//
//  ViewController.swift
//  Todo iOS 11
//
//  Created by Maximilian Dufter on 24.02.18.
//  Copyright © 2018 Maximilian Dufter. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    
    // file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask).first?.appendingPathComponent("Todos.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTodos()
    }
    
    
    // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title

        // cell.accessoryType = item.done ? .checkmark : .none
        
        if item.done == true {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor.green
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK - Add new todos
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Todo", style: .default) { (action) in
            
            let newItem = TodoItem()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Todo"
            
            textField = alertTextField
            
            print("Closure")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // persist data changes
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            // write data
            try data.write(to: self.dataFilePath!)
        } catch {
            print("ERROR! Problem occured while encoding todos.\n")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadTodos() {
        
        // Decode todos
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("ERROR! Problem occured while decoding todos.\n")
            }
            
        }
        
    }
    
}

