//
//  SocketConnection.swift
//  FingerJousting
//
//  Created by Eugene Mu on 1/16/16.
//  Copyright © 2016 E-D. All rights reserved.
//

import UIKit

protocol UsersController
{
    func usersArrayDidFill()
}

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
    var allUsers = [String]()
    
    func connectToServer() {
        socket = SocketIOClient(socketURL: "Eugenes-MacBook-Pro.local:8000")
        socket?.connect()
        socket?.on("connect") { data, ack in
            print("iPhone connected to server")
        }
        
    }
    
    func requestGame(withUser user: String) {
        socket?.emit("requestGame", user)
    }
    
    func getAllUsers(controller: UsersController) {
        socket?.emit("all-users")
        socket?.on("all-users") { data, ack in
            self.fillAllUsers(data)
            controller.usersArrayDidFill()
        }
    }
    
    private func fillAllUsers(data: [AnyObject]) {
        print("Data: \(data)")
        self.allUsers = data[0] as! [String]
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