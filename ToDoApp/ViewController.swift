//
//  ViewController.swift
//  ToDoApp
//
//  Created by Kaan Acikgoz on 7.02.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var dataArray = [Daily]()
    
    private lazy var tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private let navigationBar:UINavigationBar = {
       let navBar = UINavigationBar()
        let navItem = UINavigationItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(buttonTapped))
        navItem.rightBarButtonItem = addButton
        navBar.items = [navItem]
        
        return navBar
    }()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchData()
    }
    
    @objc private func buttonTapped() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: "enter the data you want to add please", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = textField.text else { return }
            let model = Daily(context: self.context)
            model.routine = text
            self.saveData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func saveData() {
            do {
                try context.save()
            } catch {
                print("Error saving data in coredata: \(error)")
            }
        tableView.reloadData()
    }
    
    private func fetchData() {
        let request:NSFetchRequest<Daily> = Daily.fetchRequest()
        do {
            dataArray = try context.fetch(request)
        } catch {
            print("Error reading data in coredata: \(error)")
        }
        tableView.reloadData()
    }


}

extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row].routine
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
}

