//
//  LoginViewController.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit
import Stevia

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var loginLbl = UILabel()
    var userNameField = UITextField()
    var pwdField = UITextField()
    var loginBtn = UIButton()
    var clientToTest: Client!
    var mockSession: MockURLSession!
    var midScreenHeight = UIScreen.main.bounds.height / 4
    
    // MARK: - Load View and Layout subviews

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        self.userNameField.delegate = self
        self.pwdField.delegate = self

        
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
        
    // MARK: - Login Callbacks

    @objc func loginAction(){
        print("SignIn in progress...")
        if userNameField.text == "Paolo Esposito" && userNameField.text != " " && pwdField.text != " "
        {
            // Login OK
            mockSession = createMockSession(fromJsonFile: "Login", andStatusCode: 200, andError: nil)
            clientToTest = Client(withSession: mockSession)
            clientToTest.loginCall(url: URL(string: "FakeUrl")!) { (LoginData, errorMessage) in
                
                let user = LoginData!.results.first!
                print (user)
            }
            loginOK()
        } else {
            // Login KO
            loginKO()
        }
    }
    
    func loginOK() {
        
        KeychainWrapper.standard.set(userNameField.text!, forKey: "username")
        KeychainWrapper.standard.set(pwdField.text!, forKey: "pwd")
        KeychainWrapper.standard.set(true, forKey: "logged")
        let contactsViewController = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: contactsViewController)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = navigationController
    }
    
    func loginKO() {
        
        print ("Login failed")
        let alertController = UIAlertController(title: "Failed", message: "Wrong credentials", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //When user clicks anywhere on the view dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
            self.view.endEditing(true)
        }


    //When user clicks "Return" dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    
}
