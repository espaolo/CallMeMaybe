//
//  UserCall.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 07/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import Foundation

struct UsersData: Codable {
    var results: [Users] = []
}

struct Users: Codable {
    var userId: Int
    var userName: String
    var userAvatar: String
}


