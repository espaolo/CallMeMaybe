//
//  LoginViewController.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit
import Stevia

class LoginViewController: UIViewController {
    
    var loginLbl = UILabel()
    var userNameField = UITextField()
    var pwdField = UITextField()
    var loginBtn = UIButton()
    
    var midScreenHeight = UIScreen.main.bounds.height / 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.subviews(
            loginLbl.style({v in
                v.text = "CallMe Maybe"
                v.textColor = UIColor.blue
                v.font = UIFont(name: "GillSans-UltraBold", size: 17)
                v.width(100)
                v.textAlignment = .center
            }),
            userNameField.style({v in
                v.placeholder = "Enter Username"
                v.borderStyle = .roundedRect
                
            }),
            pwdField.style({v in
                v.isSecureTextEntry = true
                v.returnKeyType = .done
                v.placeholder = "Enter Password"
                v.borderStyle = .roundedRect
            }),
            loginBtn.style({ (v) in
                v.width(100)
                v.setTitle("Login", for: .normal)
                v.backgroundColor = UIColor.blue
                v.setTitleColor(UIColor.white, for: .normal)
                v.layer.cornerRadius = 5
                
            })
        )
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.layout(
            midScreenHeight,
            |-loginLbl.centerHorizontally().centerVertically()-| ~ 50,
            20,
            |-30-userNameField-30-| ~ 50,
            20,
            |-30-pwdField-30-| ~ 50,
            30,
            |-loginBtn.centerHorizontally()-| ~ 45
        )
    }
        
    @objc func loginAction(){
        print("Good Morning")
        UserDefaults.standard.set(true, forKey: "logged")
        UserDefaults.standard.synchronize()
        let contactsViewController = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: contactsViewController)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = navigationController
    }
    


}

