//
//  ViewController.swift
//  Todo iOS 11
//
//  Created by Maximilian Dufter on 24.02.18.
//  Copyright © 2018 Maximilian Dufter. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    
    // get the persistent Container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // file path
        let dataFilePath = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first?.appendingPathComponent("Todos.plist")
        
        print(dataFilePath!)
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK - Add new todos
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Todo", style: .default) { (action) in
            
            // from saveContext()
            // rows in table (NSManagedObject)
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
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
        
        do {
            try context.save()
        } catch {
            print("ERROR! Problem occured while saving context.\n")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadTodos() {

        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("ERROR! Problem occured while fetching data.\n")
        }
        

    }
    
}

