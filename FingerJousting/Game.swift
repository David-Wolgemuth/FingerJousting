//
//  File.swift
//  FingerJousting
//
//  Created by David Wolgemuth on 1/15/16.
//  Copyright © 2016 E-D. All rights reserved.
//

import UIKit

class Game
{
    let images: [UIImage]
    var gameBoard = [2, 0, 3, 4]
    var playersTurn = true
    var currentMove = [Int]()
    var validMoves = [Bool]()
    
    init()
    {
        var images = [UIImage]()
        for i in 0...4 {
            let img = UIImage(named: "\(i)-fingers.png")!
            images.append(img)
        }
        self.images = images
        showValidMoves()
    }
    func randomGameBoard()
    {
        for i in 0..<gameBoard.count {
            gameBoard[i] = Int(arc4random_uniform(5))
        }
    }
    func showValidMoves()
    {
        validMoves = [false, false, false, false]
        if currentMove.count == 0 {
            if gameBoard[2] > 0 {
                validMoves[2] = true
            }
            if gameBoard[3] > 0 {
                validMoves[3] = true
            }
        } else {
            let move = currentMove[0]
            if gameBoard[2] == 0 && gameBoard[move] % 2 == 0 {
                validMoves[2] = true
            }
            if gameBoard[3] == 0 && gameBoard[move] % 2 == 0 {
                validMoves[3] = true
            }
            if gameBoard[0] > 0 {
                validMoves[0] = true
            }
            if gameBoard[1] > 0 {
                validMoves[1] = true
            }
        }
    }
    
}