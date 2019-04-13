//
//  GameScene.swift
//  RollingDiceGame
//
//  Created by Kulpreet Singh on 2019-03-10.
//  Copyright © 2019 Kulpreet Singh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var background = SKSpriteNode()
    var gameBoard = SKSpriteNode()
    var player = SKSpriteNode()
    var computer = SKSpriteNode()
    var playerImage = SKSpriteNode()
    var computerImage = SKSpriteNode()

    
    var turnOfPlayer: Bool = true
    var rollingOfDice: Bool = false
    var moveFinished: Bool = true
    var gameOver: Bool = false
    
    var playerPosition: Int = 0
    var computerPosition: Int = 0
    
    var playerLabel = SKLabelNode()
    var computerLabel = SKLabelNode()
    var playerPositionLabel = SKLabelNode()
    var computerPositionLabel = SKLabelNode()
    var winLabel = SKLabelNode(fontNamed: "Avenir-Book")
    
    // snake and ladder positions
    let snakePosition = [15:7, 22:17, 67:46, 86:64, 96:71]
    let ladderPosition = [29:32, 44:56, 52:74, 59:84, 81:100]
  
    //z-index positions
    enum objectZPositions: CGFloat {
        case background = 0
        case board = 1
        case players = 2
        case playersImage = 3
        case labels = 4
        case dice = 5
        case button = 6
        case winlabel = 7
    }
    
    //left and right positions on X-axis
    var leftX: CGFloat = 0
    var rightX: CGFloat = 0
    
    //Dice
    var rolledDice: Int = 0

    
    override func didMove(to view: SKView) {
        
      setupBoard()
      setupPlayers()
      startGame()
      addRestartButton()
        
        let dice = SKSpriteNode(imageNamed: "dice1")
        dice.name = "dice"
        dice.position = CGPoint(x: self.rightX, y: 0)
        dice.zPosition = objectZPositions.dice.rawValue
        self.addChild(dice)
        
////        restartButton.zPosition = objectZPositions.button.rawValue
//        restartButton.position = CGPoint(x: rightX, y: gameBoard.size.width/3)
//        addChild(restartButton)
    }
    
    func setupBoard() {
        
        //set background image
        background = SKSpriteNode(imageNamed: "background")
        //set gameboard image
        gameBoard = SKSpriteNode(imageNamed: "game board")
        //set gameboard size
        gameBoard.size = CGSize(width: self.frame.width / (16.0 / 7.0), height: self.frame.width / (16.0 /  7.0))
        //stack the gameboard in layers
        gameBoard.zPosition = objectZPositions.board.rawValue
        
        //add the objects in the gameScene
        addChild(background)
        addChild(gameBoard)
    }
    
    func setupPlayers(){
        
        playerLabel = SKLabelNode(fontNamed: "Helvetica")
        playerLabel.fontSize = 16
        playerLabel.fontColor = UIColor.white
        playerLabel.text = "Player"
        
        computerLabel = SKLabelNode(fontNamed: "Helvetica")
        computerLabel.fontSize = 16
        computerLabel.fontColor = UIColor.white
        computerLabel.text = "Computer"
        
        //set the positions of Human player and computer player labels
        leftX = -gameBoard.size.width/2 - (self.frame.width - gameBoard.size.width)/4
        let leftYForPlayerLabel = gameBoard.size.height/2 - playerLabel.frame.height - 90
        rightX = gameBoard.size.width/2 + (self.frame.width - gameBoard.size.width)/4
        
        playerLabel.position = CGPoint(x: leftX, y: leftYForPlayerLabel)
        playerLabel.zPosition = objectZPositions.labels.rawValue
        addChild(playerLabel)
        
        let leftYForComputerLabel = gameBoard.size.height/2 - computerLabel.frame.height - 210
        
        computerLabel.position = CGPoint(x: leftX, y: leftYForComputerLabel)
        computerLabel.zPosition = objectZPositions.labels.rawValue
        addChild(computerLabel)
        
        //set the image of Human player and computer player
        playerImage = SKSpriteNode(imageNamed: "player")
        player = SKSpriteNode(imageNamed: "Human-player")
        //set the Player image 
        let playerImageSize = self.frame.width / 4 - 130
        let playerSize = gameBoard.frame.width/10/2
        playerImage.size = CGSize(width: playerImageSize, height: playerImageSize)
        player.size = CGSize(width: playerSize, height: playerSize)
        let leftYForPlayerImage = gameBoard.size.height/2 - playerImage.frame.height - 5
        let leftYForPlayer = gameBoard.size.height/2 - playerImage.frame.height - 20
        
        playerImage.position = CGPoint(x: leftX, y: leftYForPlayerImage)
        player.position = CGPoint(x: leftX, y: leftYForPlayer)
        playerImage.zPosition = objectZPositions.playersImage.rawValue
        player.zPosition = objectZPositions.players.rawValue
        player.alpha = 0.6
        addChild(player)
        addChild(playerImage)
        
        computerImage = SKSpriteNode(imageNamed: "enemy")
        computer = SKSpriteNode(imageNamed: "Computer-player")
        let computerImageSize = self.frame.width / 4 - 130
        let computerSize = gameBoard.frame.width/10/2
        computerImage.size = CGSize(width: computerImageSize, height: computerImageSize)
        computer.size = CGSize(width: computerSize, height: computerSize)
        let leftYForComputerImage = gameBoard.size.height/2 - computerImage.frame.height - 120
        let leftYForComputer = gameBoard.size.height/2 - computerImage.frame.height - 135
        
        computerImage.position = CGPoint(x: leftX, y: leftYForComputerImage)
        computer.position = CGPoint(x: leftX, y: leftYForComputer)
        computerImage.zPosition = objectZPositions.playersImage.rawValue
        computer.zPosition = objectZPositions.players.rawValue
        computer.alpha = 0.6
        addChild(computer)
        addChild(computerImage)
    
    }
    
    func calculatePlayerPosition(position: CGFloat) -> CGPoint {
        
        let startingPointX = -gameBoard.frame.width/2
        let startingPointY = -gameBoard.frame.height/2
        
        let boxSize: CGFloat = gameBoard.size.width / 10
        
        let row: Int = Int(ceil(position/10.0))
        var col: Int = 0
        
        if Int(position) % 10 == 0{
            if (Int(position) / 10) % 2 == 0{
                col = 1
            }
            else {
                col = 10
            }
        }
        else if row % 2 == 0{
            col = 10 - Int(position) % 10 + 1
        }
        else {
            col = Int(position) % 10
        }
        
        let destinationX = startingPointX + (boxSize / 2) + (CGFloat(col - 1) * boxSize)
        let destinationY = startingPointY + (boxSize / 2) + (CGFloat(row - 1) * boxSize)
        
        return CGPoint(x: destinationX, y: destinationY)
    }
    
    func movePlayer(actualPlayer: Bool, position: CGFloat) {
        
        let newPoint = calculatePlayerPosition(position: position)
        let moveAction = SKAction.move(to: newPoint, duration: 2)
        if actualPlayer {
            player.run(moveAction, completion: {
    
            for key in self.ladderPosition.keys {
                if key == Int(position){
                self.playerPosition = self.ladderPosition[key]!
                self.movePlayer(actualPlayer: true, position: CGFloat(self.playerPosition))
            }
            }
            
            for key in self.snakePosition.keys {
                if key == Int(position){
                    self.playerPosition = self.snakePosition[key]!
                    self.movePlayer(actualPlayer: true, position: CGFloat(self.playerPosition))
                    
                }
            }
                self.moveFinished = true
                self.turnOfPlayer = false
                self.flashTurn(actualPlayer: false)
                self.diceRoll(actualPlayer: false)
                self.checkWin()
        })
        }
        else {
            computer.run(moveAction, completion: {
            
            for key in self.ladderPosition.keys {
                if key == Int(position){
                    self.computerPosition = self.ladderPosition[key]!
                    self.movePlayer(actualPlayer: false, position: CGFloat(self.computerPosition))
                }
            }
            
            for key in self.snakePosition.keys {
                if key == Int(position){
                    self.computerPosition = self.snakePosition[key]!
                    self.movePlayer(actualPlayer: false, position: CGFloat(self.computerPosition))
                    
                }
            }
                self.moveFinished = true
                self.turnOfPlayer = true
                self.flashTurn(actualPlayer: true)
                self.checkWin()
          })
        }
    }
    
    func diceRoll(actualPlayer: Bool) {
        print("came in diceRoll")

        if gameOver || rollingOfDice || !moveFinished {
            return
        }
        moveFinished = false
        rollingOfDice = true
        
        self.enumerateChildNodes(withName: "dice") { (diceNode, stop ) in
            diceNode.removeFromParent()
        }
        
        var diceImages = [SKTexture]()
        
        for _ in 0..<10{
            let random = GKRandomSource()
            let dice3d6 = GKGaussianDistribution(randomSource: random, lowestValue: 1, highestValue: 6)
            rolledDice = dice3d6.nextInt()
            let imageName = "dice\(rolledDice)"
            let diceImage = SKTexture(imageNamed: imageName)
            diceImages.append(diceImage)
        }
     
        
        let dice = SKSpriteNode(imageNamed: "dice1")
        dice.name = "dice"
        dice.position = CGPoint(x: rightX, y: 0)
        dice.zPosition = objectZPositions.dice.rawValue
        addChild(dice)
        
        let diceAnimation = SKAction.animate(with: diceImages, timePerFrame: 0.2)
        
        dice.run(diceAnimation) {
            self.rollingOfDice = false
            if actualPlayer{
                
                if self.playerPosition + self.rolledDice <= 100 {
                    self.playerPosition += self.rolledDice
                    self.movePlayer(actualPlayer: true, position: CGFloat(self.playerPosition))
                }
                else if self.playerPosition + self.rolledDice > 100 {
                    self.playerPosition = 100
                    self.movePlayer(actualPlayer: true, position: CGFloat(self.playerPosition))
                    self.moveFinished = true
                    self.gameOver = true
                }
            }
            else {
                if self.computerPosition + self.rolledDice <= 100 {
                    self.computerPosition += self.rolledDice
                    self.movePlayer(actualPlayer: false, position: CGFloat(self.computerPosition))
                }
                else if self.computerPosition + self.rolledDice > 100 {
                    self.computerPosition = 100
                    self.movePlayer(actualPlayer: false, position: CGFloat(self.computerPosition))
                    self.moveFinished = true
                    self.gameOver = true
                }
            }
            
        }
    }
    
    func startGame() {
        
        if !turnOfPlayer {
            diceRoll(actualPlayer: false)
            flashTurn(actualPlayer: false)
        }
        else {
            
            flashTurn(actualPlayer: true)
        }
    }
    
    func flashTurn(actualPlayer: Bool) {
    
        if actualPlayer {
            computerLabel.removeAllActions()
            computerLabel.alpha = 1
            computerLabel.setScale(1)
            playerLabel.run(SKAction.init(named: "Pulse")!)
        }
        else {
            playerLabel.removeAllActions()
            playerLabel.alpha = 1
            playerLabel.setScale(1)
            computerLabel.run(SKAction.init(named: "Pulse")!)
        }
    }
    
    func checkWin() {
        
        if playerPosition >= 100 {
            gameOver = true
            displayWinLabel(txt: "You Won")
            resetLabels()
        }
        else if computerPosition >= 100 {
            gameOver = true
            displayWinLabel(txt: "Computer Won")
            resetLabels()
        }
    }
    
    func resetLabels() {
        
        playerLabel.removeAllActions()
        playerLabel.alpha = 1
        playerLabel.setScale(1)
        computerLabel.removeAllActions()
        computerLabel.alpha = 1
        computerLabel.setScale(1)
        
    }
    
    
    func displayWinLabel(txt: String) {
        
        winLabel.fontColor = UIColor.red
        winLabel.fontSize = 80
        winLabel.text = txt
        winLabel.zPosition = objectZPositions.winlabel.rawValue
        addChild(winLabel)
        
        winLabel.run(SKAction.init(named: "Pulse")!)
        
    }
    
    func testing() {
        winLabel.removeFromParent()
        self.playerPosition = 90
        self.computerPosition = 89
        self.rolledDice = 1
        self.movePlayer(actualPlayer: true, position: CGFloat(self.playerPosition))
        self.movePlayer(actualPlayer: false, position: CGFloat(self.computerPosition))
    }
    
    func addRestartButton() {
        let restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.name = "restart"
        restartButton.zPosition = objectZPositions.button.rawValue
        restartButton.position = CGPoint(x: rightX, y: gameBoard.size.width/3)
        addChild(restartButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for touch in touches {
        enumerateChildNodes(withName: "//*", using: { (node, stop) in
            
            if node.name == "dice" {
                if node.contains(touch.location(in: self)){
                    self.gameOver = false
                    if self.turnOfPlayer && !self.gameOver && !self.rollingOfDice && self.moveFinished {
                        self.diceRoll(actualPlayer: true)
                    }
                }
            }
            if node.name == "restart" {
                if node.contains(touch.location(in: self)){
                    
//                    self.testing()
                    self.winLabel.removeFromParent()
                    self.resetLabels()
                    self.playerPosition = 1
                    self.computerPosition = 1
                    self.rolledDice = 0
                    self.movePlayer(actualPlayer: true, position: CGFloat(self.playerPosition))
                    self.movePlayer(actualPlayer: false, position: CGFloat(self.computerPosition))
                    self.gameOver = true
                }
             }
            
            })
        }
    }
}
