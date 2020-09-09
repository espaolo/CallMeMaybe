//
//  RoomDelegate.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 09/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import Foundation


protocol RoomDelegate: class {
    func didConnect(username: String)
    func didDisconnect(username: String)
    func addStream(_ : CallStream)
    func removeStream(_ : CallStream)
}

// Making optionals two methods
extension RoomDelegate {
    func addStream(_ : CallStream) {
        return
    }
    func removeStream(_ : CallStream) {
        return
    }

}

// Custom CallStream Class with random values
class CallStream {
    var hasAudio: Bool!
    var hasVideo: Bool!
    
    init() {
        hasAudio = Bool.random()
        hasVideo = Bool.random()

    }
    func toggleAudio() {
        hasAudio.toggle()
    }
    func toggleVideo() {
        hasVideo.toggle()
    }
}

// Room Class with delegate emission
class Room {
    private var numberOfGuests: Int!
    
    weak var delegate: RoomDelegate?

    init() {
        numberOfGuests = 0
    }
    
    func userHasJoined(guest: String) {
        numberOfGuests += 1
        delegate?.didConnect(username: guest)
        print("The number of guests in the room now is: " + "\(numberOfGuests!)")
    }
    func userLeaved(guest: String) {
        if numberOfGuests > 0{
            delegate?.didDisconnect(username: guest)
            numberOfGuests -= 1
        }
        print("The number of guests in the room now is: " + "\(numberOfGuests!)")
    }
}


