//
//  CallViewController.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit
import AVFoundation
import Stevia
import CallMeKit

class CallViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, RoomDelegate {
    
    var contactsList: [String] = []
    let localRoom = Room()

    // MARK: - Load Call View and user camera preview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        let previewView = CameraView()

        let steviaHeight = view.frame.height/2
        let v1 = UserCallView()
        let v2 = UserCallView()
        let v3 = UserCallView()
        let v4 = UserCallView()
        let btn = UIButton(type: .custom)
        localRoom.delegate = self

        print(contactsList)
        for user in contactsList {
            localRoom.userHasJoined(guest: user)
        }
        
        // MARK: - Parametric View layout for 1/2/3/4 users
        
        // One user
        if contactsList.count == 1 {
            v1.labelName.text = contactsList[0]
            view.subviews(v1,previewView,btn)
            view.layout(
                80,
                |v1| ~ steviaHeight
            )
            previewView.right(8)
            previewView.bottom(25)
            previewView.size(100)
            btn.left(8)
            btn.bottom(25)
            btn.style({v in
                v.setTitle("End Call", for: .normal)
                v.backgroundColor = .red
                v.size(100)
                v.clipsToBounds = true
                v.layer.cornerRadius = 50
                v.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                v.layer.borderWidth = 3.0
            })
            btn.addTarget(self,action: #selector(closeAction), for: .touchUpInside)
        }
        // Two Users
        if contactsList.count == 2 {
            v1.labelName.text = contactsList[0]
            v2.labelName.text = contactsList[1]
            view.subviews(v1,v2,previewView,btn)
            view.layout(
                0,
                |v1| ~ steviaHeight,
                0,
                |v2| ~ steviaHeight,
                0
            )
            previewView.right(8)
            previewView.bottom(25)
            previewView.size(100)
            btn.left(8)
            btn.bottom(25)
            btn.style({v in
                v.setTitle("End Call", for: .normal)
                v.backgroundColor = .red
                v.size(100)
                v.clipsToBounds = true
                v.layer.cornerRadius = 50
                v.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                v.layer.borderWidth = 3.0
            })
            btn.addTarget(self,action: #selector(closeAction), for: .touchUpInside)
        }
        // Three Users
        if contactsList.count == 3 {
            v1.labelName.text = contactsList[0]
            v2.labelName.text = contactsList[1]
            v3.labelName.text = contactsList[2]
            v1.width(view.frame.width/2)
            v2.width(view.frame.width/2)
            v3.width(view.frame.width/2)
            
            view.subviews(v1,v2,v3,previewView,btn)
            view.layout(
                44,
                |-40-v1.height(steviaHeight-44)-40-|,
                0,
                |v2-v3| ~ steviaHeight,
                0
            )
            previewView.right(8)
            previewView.bottom(25)
            previewView.size(100)
            btn.left(8)
            btn.bottom(25)
            btn.style({v in
                v.setTitle("End Call", for: .normal)
                v.backgroundColor = .red
                v.size(100)
                v.clipsToBounds = true
                v.layer.cornerRadius = 50
                v.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                v.layer.borderWidth = 3.0
            })
            btn.addTarget(self,action: #selector(closeAction), for: .touchUpInside)
        }
        // Four Users
        if contactsList.count == 4 {
            v1.labelName.text = contactsList[0]
            v2.labelName.text = contactsList[1]
            v3.labelName.text = contactsList[2]
            v4.labelName.text = contactsList[3]
            v1.width(view.frame.width/2)
            v2.width(view.frame.width/2)
            v3.width(view.frame.width/2)
            v4.width(view.frame.width/2)
            
            view.subviews(v1,v2,v3,v4,previewView,btn)
            view.layout(
                44,
                |v1.height(steviaHeight-44)-v2.height(steviaHeight-44)|,
                0,
                |v3-v4| ~ steviaHeight,
                0
            )
            previewView.right(8)
            previewView.bottom(25)
            previewView.size(100)
            btn.left(8)
            btn.bottom(25)
            btn.style({v in
                v.setTitle("End Call", for: .normal)
                v.backgroundColor = .red
                v.size(100)
                v.clipsToBounds = true
                v.layer.cornerRadius = 50
                v.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                v.layer.borderWidth = 3.0
            })
            btn.addTarget(self,action: #selector(closeAction), for: .touchUpInside)
        }
    }
    
    // MARK: - Close Call Action

    @objc func closeAction(){
        for user in contactsList {
            localRoom.userLeaved(guest: user)
        }

        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Room Delegates
    func didConnect(username: String) {
        print ("The user: " + username + " has joined")
    }
    
    func didDisconnect(username: String) {
        print ("The user: " + username + " leaved")
    }

    
}
