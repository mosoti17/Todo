//
//  CategoryViewController.swift
//  Todo
//
//  Created by Elvis Mogaka on 11/19/18.
//  Copyright © 2018 Elvis Mogaka. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewControler {
    
    var categoryArray : Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArray?[indexPath.row] {
            let color = UIColor(hexString: category.backgroundColor)
            cell.textLabel?.text = category.name
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        } 
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewControler
        if let  indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }



    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) {
            (action) in
            let category = Category()
            category.name = textField.text!
            category.backgroundColor = UIColor.randomFlat.hexValue()
            self.save(category: category)
            
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Add category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func save(category :Category)  {
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()  {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    override func updateModel(at indexPath: IndexPath) {
   
            if let category = self.categoryArray?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(category)

                    }
                }catch{
                    print("Error deleting category \(error)")
                }
            }
    
    }
}


