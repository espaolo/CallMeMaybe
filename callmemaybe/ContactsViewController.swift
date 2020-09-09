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
    
    //  let contactsList = ["Guglielmo Cancelli", "Bruno Solfrizzi", "Enrico Morossi", "Giovanni Falanga", "Timoteo Cuoco", "Nicola Bandini", "Fernet Branca"]
    
    // We take the contacts list from mocked Network Call via RetrieveAction func
    var contactsList: [String] = []
    var clientToTest: Client!
    var mockSession: MockURLSession!
    var contactsDetailsArray: [String] = []
    let btn = UIButton(type: .custom)
    var selectedItems = 0
    
    // MARK: - Load View and layout subviews
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Contacts to call"
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: "contactCell")
        tableView.rowHeight = 50
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
        btn.bottom(20)
        btn.style({v in
            v.setTitle("Start Call", for: .normal)
            v.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            v.size(100)
            v.clipsToBounds = true
            v.layer.cornerRadius = 50
            v.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            v.layer.borderWidth = 3.0
        })
        btn.addTarget(self,action: #selector(captureAction), for: .touchUpInside)
        btn.isHidden = true        
        tableView.left(0).right(0).top(0).bottom(0)
        retrieveAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        selectedItems = 0
        contactsDetailsArray = []
        tableView.reloadData()
        
    }

    
    // MARK: - Logout user

    @objc func logoutAction() {
        
        KeychainWrapper.standard.removeObject(forKey: "logged")
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = navigationController
    }
    
    // MARK: - TableView delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        cell.textLabel?.text = contactsList[indexPath.row]
        cell.userAvatar.image = UIImage(named: "PersonCircle")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if tableView.indexPathsForSelectedRows?.count == 4 {
            return nil
        }
        // Increment selected items and append the contact to Contacts Array
        selectedItems += 1
        contactsDetailsArray.append(contactsList[indexPath.row])
        // When contacts are selected the call button is visible
        btn.isHidden = false
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        //Decrement selected items
        selectedItems -= 1
        // If no elements are selected the Call button is hidden and Contacts array is empty
        if selectedItems == 0 {
            print ("Zero selected")
            contactsDetailsArray.removeAll()
            btn.isHidden = true
        }
        else {
            // When deselct a row remove the contact from array
            if let index = contactsDetailsArray.firstIndex(of: contactsList[indexPath.row]) {
                contactsDetailsArray.remove(at: index)
            }
        }
        return indexPath
    }
    
    // MARK: - Users Retrieval from Mock API

    func retrieveAction() {
        // User retrival OK
        mockSession = createMockSession(fromJsonFile: "Users", andStatusCode: 200, andError: nil)
        clientToTest = Client(withSession: mockSession)
        clientToTest.userRetrieveCall(url: URL(string: "FakeUrl")!) { (RetData, errorMessage) in
            
            let users = RetData!.results
            for user in users{
                self.contactsList.append(user.userName)
            }
        }
    }
    
    @objc func captureAction(){
        if (contactsDetailsArray.count > 0){
            let vc = CallViewController()
            vc.contactsList = contactsDetailsArray
            self.navigationController?.pushViewController(vc, animated: true)
            displayCallPendingAlert()
            //self.navigationController?.pushViewController(vc, animated: true)
        }
                
    }
    
    func displayCallPendingAlert() {
        //Create an alert controller
        let pending = UIAlertController(title: "Join...", message: nil, preferredStyle: .alert)
        
        //Create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //Add the activity indicator as a subview of the alert controller's view
        pending.view.subviews(indicator)
        indicator.centerHorizontally()
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        // Present the View
        self.parent?.present(pending, animated: true, completion: nil)
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            // Dismiss after 3 seconds
            indicator.stopAnimating()
            pending.dismiss(animated: true, completion: nil)
        }
    }


}
