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
    func requestReceived(fromUser user: String)
    func gameDidStart(isPlayer1 player1: Bool)
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
            print("Connected to Server")
        }
    }
    func requestGame(withUser user: String) {
        socket?.emit("requestGame", user)
    }
    func waitForRequests(controller: UsersController)
    {
        socket?.on("user-request") { data, ack in
            print("Request Received")
            let user = data[0] as! String
            controller.requestReceived(fromUser: user)
        }
        socket?.on("start-game") { data, ack in
            let playersTurn = data[0] as! Bool
            controller.gameDidStart(isPlayer1: playersTurn)
        }
    }
    func getAllUsers(controller: UsersController)
    {
        socket?.emit("all-users")
        socket?.on("all-users") { data, ack in
            print("List of Users Received")
            self.fillAllUsers(data)
            controller.usersArrayDidFill()
        }
    }
    private func fillAllUsers(data: [AnyObject]) {
        self.allUsers = data[0] as! [String]
    }
    func sendToServer(GameMoves move: [Int]) {
        socket?.emit("ToServer", move)
    }
    func sendResponseToInvitation(response: Bool)
    {
        socket?.emit("response", response)
    }
    func sendToServer(userName name: String) {
        socket?.emit("user-name", name)
    }
    private init()
    {
        connectToServer()
    }
}