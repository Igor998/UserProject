//
//  ViewController.swift
//  UserProject
//
//  Created by Igor Baric on 4/17/19.
//  Copyright © 2019 ItFusion. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  AddUserViewControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var userList: [User] = [User]()
    var userList2: [User] = [User]()
    var selectedUser : User?
    var editButtonClicked : Bool = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        do {
            let userDefaults = UserDefaults.standard
            if let data = userDefaults.data(forKey: "people") {
                let encodedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [User]
                self.userList = encodedData
                
            }
            
            
        } catch {
            print(error)
            
        }
        tableView.reloadData()
        
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        self.userList2.removeAll(keepingCapacity: false)
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        let array = userList.filter {
            return $0.fullName()!.range(of: searchText) != nil
        }
        
        self.userList2 = array
        
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onButtonClickAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: String(describing: AddUserViewController.self)) as! AddUserViewController
        destinationVC.delegate = self
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return self.userList2.count
        } else {
            return self.userList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        let user = userList[indexPath.row]
        cell?.textLabel?.text = user.fullName()
        
        if searchController.isActive {
            cell?.textLabel?.text = userList2[indexPath.row].fullName()
        } else {
            cell?.textLabel?.text = user.fullName()
        }
        
        
        return cell!
    }
    
    func addUserViewControllerDidSaveUser(user: User!) {
        let index = userList.firstIndex(where: {$0 === user})
        if let i = index {
            userList[i] = user
            editButtonClicked = false
        } else {
            userList.append(user)
        }
        do {
            let userDefaults = UserDefaults.standard
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: userList, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "people")
            userDefaults.synchronize()
            
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func addUserViewControllerDidSaveAccount(account: Account!) {
        guard let user = account.user else{
            return
        }
        let index = userList.firstIndex(where: {$0 === user})
        if let i = index {
            userList[i] = user
            editButtonClicked = false
        } else {
            userList.append(user)
        }
        do {
            let userDefaults = UserDefaults.standard
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: userList, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "people")
            userDefaults.synchronize()
            
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchController.isActive {
            selectedUser = userList2[indexPath.row]
            self.editButtonClicked = true
            if (self.selectedUser != nil){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: String(describing: AddUserViewController.self)) as! AddUserViewController
                destinationVC.delegate = self
                if self.editButtonClicked {
                    destinationVC.userToEdit = self.selectedUser
                    self.editButtonClicked = false
                    self.selectedUser = nil
                }
                searchController.isActive = false
                self.navigationController?.pushViewController(destinationVC, animated: true)                
            }
            
        } else {
            selectedUser = userList[indexPath.row]
            self.editButtonClicked = true
            if (self.selectedUser != nil){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: String(describing: AddUserViewController.self)) as! AddUserViewController
                destinationVC.delegate = self
                if self.editButtonClicked {
                    destinationVC.userToEdit = self.selectedUser
                    self.editButtonClicked = false
                    self.selectedUser = nil
                }
                self.navigationController?.pushViewController(destinationVC, animated: true)
                
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
                self.userList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.selectedUser = nil
                self.tableView.reloadData()
            
        }
        
        do {
            let userDefaults = UserDefaults.standard
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: userList, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "people")
            userDefaults.synchronize()
            
        } catch {
            print(error)
        }
        self.tableView.reloadData()

    }
    
   
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        self.selectedUser = nil
        return true
    }
    
    
    
}





