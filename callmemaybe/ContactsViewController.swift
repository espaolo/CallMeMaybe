//
//  ContactsViewController.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        let rightBarButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutAction))
        self.navigationItem.rightBarButtonItem = rightBarButton

    }

    @objc func logoutAction() {
        UserDefaults.standard.removeObject(forKey: "logged")
        UserDefaults.standard.synchronize()
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = navigationController
    }
    


}
