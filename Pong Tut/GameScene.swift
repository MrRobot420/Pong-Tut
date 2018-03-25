//
//  GameScene.swift
//  Pong Tut
//
//  Created by Maximilian Karl on 23.03.18.
//  Copyright © 2018 Carlos Company. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    
    var score = [Int]()
    
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
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
        
        // Border all around the screen
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
    }
    
    func startGame() {
        score = [0,0]
        ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3))
        
    }
    
    
    func addScore(playerWhoWon: SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoWon == main {
            score[0] += 1
            btmLbl.text = "\(score[0])"
            ball.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 3))
        } else if playerWhoWon == enemy {
            score[1] += 1
            topLbl.text = "\(score[1])"
            
            ball.physicsBody?.applyImpulse(CGVector(dx: -3, dy: -3))
        }
        print(score)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.8))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.7))
                }
            } else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.6))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        switch currentGameType {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.165))
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.155))
            break
        case .player2:
            
            break
        
        }
        if ball.position.y <= main.position.y - 30 {
            addScore(playerWhoWon: enemy)
        } else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: main)
        }
        
    }
}
