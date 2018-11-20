//
//  CategoryViewController.swift
//  Todo
//
//  Created by Elvis Mogaka on 11/19/18.
//  Copyright © 2018 Elvis Mogaka. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
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
}
