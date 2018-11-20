//
//  ViewController.swift
//  Todo
//
//  Created by Elvis Mogaka on 11/16/18.
//  Copyright © 2018 Elvis Mogaka. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewControler: UITableViewController {
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // loadItems()
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        if   let item = todoItems?[indexPath.row] {

        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ?  .checkmark : .none
        }else {
          cell.textLabel?.text = "No items in this Category"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                   // realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error updating iten \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            print(textField.text!)
            if let curentCategory = self.selectedCategory {
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    curentCategory.items.append(newItem)
                }
            }catch{
                print("Error savinf items \(error)")
                
            }
        self.tableView.reloadData()
            }
            
            
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
       
    }
    
}
extension TodoListViewControler : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        todoItems = todoItems?.filter("title CONTAINS[cd] %@" , searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}

