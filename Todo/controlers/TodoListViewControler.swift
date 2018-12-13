//
//  ViewController.swift
//  Todo
//
//  Created by Elvis Mogaka on 11/16/18.
//  Copyright © 2018 Elvis Mogaka. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewControler: SwipeTableViewControler {
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
  
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // loadItems()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.backgroundColor  else {
            fatalError("Background Color not availble")
        }
         title = selectedCategory!.name
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "262BA3")
    }
    func updateNavBar (withHexCode colorHexCode : String){
        guard let navBar = navigationController?.navigationBar else{
            fatalError("Navigation controler does not exist")
        }
        guard let navBarColor = UIColor(hexString:colorHexCode ) else {
            fatalError("Hex code not parsed to color")
        }
            navBar.barTintColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            searchBar.barTintColor = navBarColor
        }
        
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if   let item = todoItems?[indexPath.row] {
            

        cell.textLabel?.text = item.title
            if let color = UIColor(hexString: (selectedCategory?.backgroundColor)!)?.darken(byPercentage: CGFloat(indexPath.row ) / CGFloat(todoItems!.count)){
                cell.accessoryType = item.done ?  .checkmark : .none
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        
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
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(item)
                    
                }
            }catch{
                print("Error deleting item \(error)")
            }
        }
        
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

