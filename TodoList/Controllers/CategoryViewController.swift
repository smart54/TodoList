//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Demo on 4.08.2018.
//  Copyright © 2018 RN. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))


    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // datasource ve diğerini ekle
        loadCategory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    // row seçildiğinde tetiklenir.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    // bu kısım yukarıda category item ı seçilmeden(segue perform edilmeden önce) implemente edilir.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        // bu kısım(indexPathForSelectedRow) optionaldır. Çünkü henüz bir row seçilmemiş.
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Yeni Bir Kategori Ekle", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yeni Kategori", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Yeni Bir Kategori Ekle"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func saveCategory(){
        
        do{
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("error by the time of fetching \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - TableView Datasource Methods
    
    //MARK: - Data Manipulation Methods(save data, load data)
    
    //MARK: - TableView Delegate Methods(bir kategori item ina bastığımızda ne olacak?)
    
    
}
