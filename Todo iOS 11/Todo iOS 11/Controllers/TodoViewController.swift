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
    
    var selectedCategory: Category? {
        
        // triggered, when selectedCategory gets a value
        didSet {
            
            loadTodos()
            
        }
    }
    
    // get the persistent Container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // file path
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory,
//                                                    in: .userDomainMask).first?.appendingPathComponent("Todos.plist")
//
//
        
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
            
            // From saveContext()
            // Rows in table (NSManagedObject)
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
    
    // MARK: - CRUD
    // Persist data changes
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("ERROR! Problem occured while saving context.\n")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadTodos(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
            
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("ERROR! Problem occured while fetching data.\n")
        }
        
        tableView.reloadData()
    }
}

// MARK: - Searchbar
extension TodoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        // [cd] Deactivate case and diacritic sensitivity
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Sort via title
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadTodos(with: request, predicate: predicate)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadTodos()
            
            // Async. dismiss searchBar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


