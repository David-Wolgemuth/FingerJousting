//
//  SocketConnection.swift
//  FingerJousting
//
//  Created by Eugene Mu on 1/16/16.
//  Copyright © 2016 E-D. All rights reserved.
//

import UIKit

class Connection
{
    
    var socket: SocketIOClient?
    static let sharedInstance = Connection()
    
    func connectToServer() {
        socket = SocketIOClient(socketURL: "localhost:8000")
        socket?.connect()
        socket?.on("connect") { data, ack in
            print("iPhone connected to server")
        }
    }
    
    func sendToServer(move: [Int]) {
        socket?.emit("ToServer", move)
    }
    
    init()
    {
        connectToServer()
        
    }
}