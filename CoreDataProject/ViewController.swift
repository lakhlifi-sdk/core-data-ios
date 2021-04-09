//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Lakhlifi Essaddiq on 4/7/21.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {

    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var models = [ToDoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To do list CD"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        getAllItems()
        tableView.frame = view.bounds
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector (didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Add task", message: "Enter your task", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let actionAdd = UIAlertAction(title: "Save", style: .cancel , handler: { [weak self] _ in
                
                guard let field = alert.textFields?.first , let text =  field.text , !text.isEmpty else {
                    return
                }
                
                self?.createItem(name: text)
                
        })

        alert.addAction(actionAdd)
        present(alert, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = models[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        
        let actionEdit = UIAlertAction(title: "Cancel", style: .cancel , handler: { _ in
            
                
        })
        let actionUpdat = UIAlertAction(title: "Update", style: .default , handler: { [weak self] _ in
            
            let alert = UIAlertController(title: "update task", message: "Edit your task", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            let actionAdd = UIAlertAction(title: "Save", style: .cancel , handler: { [weak self] _ in
                    
                    guard let field = alert.textFields?.first , let newText =  field.text , !newText.isEmpty else {
                        return
                    }
                    
                    self?.updateItem(item: item, newName: newText)
                    
            })

            alert.addAction(actionAdd)
            self?.present(alert, animated: true)
            
                
        })
        let actionDelet = UIAlertAction(title: "Delete", style: .destructive , handler: { [weak self] _ in
            self?.deleteItem(item: item)
        })
       

        sheet.addAction(actionEdit)
        sheet.addAction(actionUpdat)
        sheet.addAction(actionDelet)
        present(sheet, animated: true)
        
    }

    
    
    func getAllItems(){
        do{
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            //error
        }
        
    }
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
        } catch  {
            //Error
        }
        getAllItems()
    }
    
    func deleteItem(item: ToDoListItem ){
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch  {
            //Error
        }
    }
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        do {
            try context.save()
            getAllItems()
        } catch  {
            //Error
        }
        
    }
    
    



}

