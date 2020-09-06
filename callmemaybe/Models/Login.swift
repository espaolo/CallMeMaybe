//
//  Login.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 06/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import Foundation

struct LoginData: Codable {
    var results: [Login] = []
}

struct Login: Codable {
    var userId: Int
    var userName: String
}
