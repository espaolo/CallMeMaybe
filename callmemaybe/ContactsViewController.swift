//
//  ContactsViewController.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit
import Stevia

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let categoryList = ["Guglielmo Cancelli", "Bruno Solfrizzi", "Enrico Morossi", "Giovanni Falanga", "Timoteo Cuoco", "Nicola Bandini", "Fernet Branca"]
    let btn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: "contactCell")
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        self.view.backgroundColor = .red
        navigationController?.navigationBar.isHidden = false
        // View Layout
        let rightBarButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutAction))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        view.subviews(tableView)
        view.subviews(btn)
        btn.centerHorizontally()
        btn.bottom(10)
        btn.style({v in
            v.setTitle("Start Call", for: .normal)
            v.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            v.size(100)
            v.clipsToBounds = true
            v.layer.cornerRadius = 50
            v.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            v.layer.borderWidth = 3.0
        })
        
        btn.isHidden = true
        //        btn.addTarget(self,action: #selector(CallVC.buttonTapped), for: UIControlEvent.touchUpInside)
        
        tableView.left(0).right(0).top(0).bottom(0)
        
    }
    
    
    @objc func logoutAction() {
        KeychainWrapper.standard.removeObject(forKey: "logged")
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = navigationController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        cell.textLabel?.text = categoryList[indexPath.row]
        cell.userAvatar.image = UIImage(named: "PersonCircle")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathsForSelectedRows?.count == 4 {
            return nil
        }
        btn.isHidden = false
        return indexPath
    }
}
