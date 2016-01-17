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
    class var sharedInstance: Connection
    {
        struct Static
        {
            static let instance: Connection = Connection()
        }
        return Static.instance
    }
    
    var socket: SocketIOClient?
    
    func connectToServer() {
        socket = SocketIOClient(socketURL: "localhost:8000")
        socket?.connect()
        socket?.on("connect") { data, ack in
            print("iPhone connected to server")
        }
    }
    
    func sendToServer(GameMoves move: [Int]) {
        socket?.emit("ToServer", move)
    }
    
    func sendToServer(userName name: String) {
        socket?.emit("user-name", name)
    }
    
    private init()
    {
        connectToServer()
        print("Initin")
    }
}