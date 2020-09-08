//
//  Client.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 06/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import Foundation

class Client {
    
    private var session: SessionProtocol
    
    init(withSession session: SessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    
    func loginCall(url: URL, completion: @escaping  (_ netStore: LoginData?, _ errorMessage: String?) -> Void) {
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }
            
            guard let data = data else {
                completion(nil, "No Data Avaiable")
                return
            }
            
            switch statusCode {
            case 200:
                let netStore = try! JSONDecoder().decode(LoginData.self, from: data)
                completion(netStore, nil)
            case 404:
                completion(nil, "Url Not Found")
            default:
                completion(nil, "Status Code: \(statusCode)")
            }
        }
        
        dataTask.resume()
    }
    
    func userRetrieveCall(url: URL, completion: @escaping  (_ netStore: UsersData?, _ errorMessage: String?) -> Void) {
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }
            
            guard let data = data else {
                completion(nil, "No Data Avaiable")
                return
            }
            
            switch statusCode {
            case 200:
                let netStore = try! JSONDecoder().decode(UsersData.self, from: data)
                completion(netStore, nil)
            case 404:
                completion(nil, "Url Not Found")
            default:
                completion(nil, "Status Code: \(statusCode)")
            }
        }
        
        dataTask.resume()
    }

}
