//
//  ViewController.swift
//  FingerJousting
//
//  Created by David Wolgemuth on 1/15/16.
//  Copyright © 2016 E-D. All rights reserved.
//

import UIKit

class GameViewController: UIViewController
{
    var game: Game?
    
    @IBOutlet var Images: [UIImageView]!
    @IBOutlet var Buttons: [UIButton]!
    
    override func viewDidLoad()
    {
        setImages()
        setButtonColors()
    }
    func setImages()
    {
        for image in Images {
            let tile = game!.gameBoard[image.tag]
            image.image = game!.images[tile]
        }
    }
    @IBAction func buttonPressed(sender: UIButton)
    {
        if !game!.playersTurn {
            return
        }
        let tile = sender.tag
        if game!.validMoves[tile] {
            game!.currentMove.append(tile)
        }
        game!.showValidMoves()
        setButtonColors()
        if game!.currentMove.count == 2 {
            game!.currentMove = []
            game!.randomGameBoard()
            game!.showValidMoves()
            setButtonColors()
            setImages()
        }
    }
    func setButtonColors()
    {
        for button in Buttons {
            let tile = button.tag
            if game!.validMoves[tile] {
                button.backgroundColor = UIColor.blueColor()
            } else {
                button.backgroundColor = UIColor.lightGrayColor()
            }
            for move in game!.currentMove {
                if move == tile {
                    button.backgroundColor = UIColor.greenColor()
                }
            }
        }
    }
}
