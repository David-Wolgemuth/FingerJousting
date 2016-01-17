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
    func gameDidStart(gameID: String, playersTurn: Bool)
}
protocol GameSocket
{
    func gameBoardReceived(board: [Int])
    func gameOver()
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
        socket = SocketIOClient(socketURL: "https://quiet-journey-7471.herokuapp.com")
        socket?.connect()
        socket?.on("connect") { data, ack in
            print("Connected to Server")
        }
    }
    func resetConnection()
    {
        socket?.disconnect()
        connectToServer()
    }
    func requestGame(withUser user: String) {
        socket?.emit("requestGame", user)
        
    }
    func waitForRequests(controller: UsersController)
    {
        socket?.on("user-request") { data, ack in
            let user = data[0] as! String
            controller.requestReceived(fromUser: user)
        }
        socket?.on("start-game") { data, ack in
            let info = data[0] as! [AnyObject]
            let id = info[0] as! String
            let turn = info[1] as! Bool
            controller.gameDidStart(id, playersTurn: turn)
        }
        socket?.on("all-users") { data, ack in
            self.fillAllUsers(data)
            controller.usersArrayDidFill()
        }
    }
    func waitForGameBoard(controller: GameSocket)
    {
        socket?.on("game-board") { data, ack in
            let board = data[0] as! [Int]
            controller.gameBoardReceived(board)
        }
        socket?.on("game-over") { data, ack in
            controller.gameOver()
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
        socket?.emit("game-move", move)
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