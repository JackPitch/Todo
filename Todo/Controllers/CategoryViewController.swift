//
//  CategoryViewController.swift
//  Todo
//
//  Created by Jack Pitcher on 7/11/19.
//  Copyright © 2019 Jackson Pitcher. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D98F6")
        
        return cell
    }
    
    
    
    //save categories
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("error saving category")
        }
            tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("error deleting category, \(error)")
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCateogry.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "add new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    //tableview datasource methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
}
