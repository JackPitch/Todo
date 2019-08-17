//
//  ViewController.swift
//  Todo
//
//  Created by Jack Pitcher on 7/5/19.
//  Copyright © 2019 Jackson Pitcher. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
            if let colorHex = selectedCategory?.color {
                
                title = selectedCategory!.name
                
                guard let navBar = navigationController?.navigationBar else {fatalError("navigation controller does not exist")}
                
                if let navBar = UIColor(hexString: colorHex) {
            
                    navBar.barTintColor = navBarColor
                    
                    navBar.tintColor = ContrastColot(navBarColor, returnFlat: true)
                    
                    navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                    
                    searchBar.barTintColor = UIColor(hexString: colorHex)
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError("error loading colors")}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.TintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringkey.foregroundColor: flatWhite()]
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            
            if let color = FlatWhite().darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
    
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
           
            cell.textLabel?.text = "no items added"
        }
        
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
            try  realm.write {
                item.done = !item.done
                }
            } catch {
                print("error saving status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("\(error)")
                }
            }
            self.tableView.reloadData()
        }
        
            //what happens when the alert is clicked
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }catch {
                print("error deleting item, \(error)")
            }
        }
    }
}
    
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar( searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}


