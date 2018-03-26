//
//  GameScene.swift
//  Pong Tut
//
//  Created by Maximilian Karl on 23.03.18.
//  Copyright © 2018 Carlos Company. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    var menuViewController: UIViewController?
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    
    var score = [Int]()
    var backToMenu = SKSpriteNode()
    
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
    // Starts as soon, as the ball flies / the first object flies
    override func didMove(to view: SKView) {
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        // Puts enemy to the top and -50 under it
        enemy.position.y = (self.frame.height / 2) - 50
        
        // Puts enemy to the bottom and +50 above it
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height / 2) + 50
        
        backToMenu = self.childNode(withName: "back") as! SKSpriteNode
        
        // Border all around the screen
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
    }
    
    // Starts the game
    func startGame() {
        score = [0,0]
        ball.physicsBody?.applyImpulse(CGVector(dx: 4, dy: 4))
        
    }
    
    
    // Adds to the score of the player who won -> Eventually other ball speeds for other levels
    func addScore(playerWhoWon: SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 4, dy: 4)
        print(">> Slowed down impulse to zero.")
        
        if playerWhoWon == main {
            score[0] += 1
            btmLbl.text = "\(score[0])"
            ball.physicsBody?.applyImpulse(CGVector(dx: 4, dy: 4))
            print(">> Applying impulse towards enemy.")
        } else if playerWhoWon == enemy {
            score[1] += 1
            topLbl.text = "\(score[1])"
            ball.physicsBody?.applyImpulse(CGVector(dx: -4, dy: -4))
            print(">> Applying impulse towards main.")
        }
        print("## SCORE: ##\n## main:  " + String(score[0]) + "\n## enemy: " + String(score[1]))
    }
    
    // Tracks user interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            // Only in two player mode! -> Can be the cause of a lag (user touches at bottom, top moves)
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
            
            // Should trigger pause-menu
            if ((location.y >= 45) && (location.y <= -45)) && ((location.x >= -355) && (location.x <= -265)) {
                
            }
        }
    }
    
    // Not working, should go back to the main menu
    func moveToMenu() {
        //should checnge to main menu
        //self.navigationController?.pushViewController(menuVC, animated: true)
        
    }
    
    
    // Same as above (only movement is tracked also)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    // Updates the screen (~60fps)
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        switch currentGameType {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.088))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.085))
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.08))
            break
        case .player2:
            
            break
        
        }
        
        // Tracks, if the ball is behind a player
        if ball.position.y <= main.position.y - 30 {
            addScore(playerWhoWon: enemy)
        } else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: main)
        }
        
    }
}
