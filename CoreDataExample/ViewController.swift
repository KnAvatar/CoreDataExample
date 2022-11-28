//
//  ViewController.swift
//  CoreDataExample
//
//  Created by ddukk17 on 24.11.22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var Table: UITableView!
    private var models = [ToDoListItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAllItems()
        Table.delegate = self
        Table.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "SUBMIT", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            self.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete?", message: "Delete Selected Item", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteItem(item: self.models[indexPath.row])
            self.Table.reloadData()
        }))
        present(alert, animated: true)
        
    }
    //Core data
    func getAllItems() {
        do{
            models = try context.fetch(ToDoListItem.fetchRequest())
            Table.reloadData()
        }
        catch{
            print("not get")
        }
    }
    
    func createItem(name: String) {
        let newitem = ToDoListItem(context: context)
        newitem.name = name
        newitem.createdAt = Date()
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        do{
            try context.save()
        }
        catch{
            
        }
        
    }
    

}

