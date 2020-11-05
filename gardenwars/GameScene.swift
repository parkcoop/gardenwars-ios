//
//  GameScene.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/4/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
     
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode(imageNamed: "image/sky")
    let player = SKSpriteNode(imageNamed: "image/me")
    let arrowLeft = SKSpriteNode(imageNamed: "image/arrowleft")
    let arrowRight = SKSpriteNode(imageNamed: "image/arrowright")
    let arrowUp = SKSpriteNode(imageNamed: "image/arrowup")
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = -5
        
        arrowLeft.name = "left"
        arrowLeft.position = CGPoint(x: ((-self.size.width / 3) - 60), y: -self.size.height / 3)
        arrowLeft.size = CGSize(width: 50, height: 20)
        arrowLeft.zPosition = 10
        
        arrowRight.name = "right"
        arrowRight.position = CGPoint(x: ((-self.size.width / 3)), y: -self.size.height / 3)
        arrowRight.size = CGSize(width: 50, height: 20)
        arrowRight.zPosition = 10

        arrowUp.name = "up"
        arrowUp.position = CGPoint(x: ((self.size.width / 3)), y: -self.size.height / 3)
        arrowUp.size = CGSize(width: 50, height: 20)
        arrowUp.zPosition = 10
        
        player.position = CGPoint(x: 0, y: 0)
        player.size = CGSize(width: 30, height: 50)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        
        
        addChild(player)
        addChild(background)
        addChild(arrowLeft)
        addChild(arrowRight)
        addChild(arrowUp)

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
     
        
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0)
                ])
            ))
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        for touch in touches {
          let location = touch.location(in: self)
          let touchedNode = self.nodes(at: location)
          for node in touchedNode {
//              if node.name == "play_button" {
//                  startGame()
//              }
            if node.name == "left" {

                player.position.x -= 25

            }
            if node.name == "right" {
              player.position.x += 25
            }
            if node.name == "up" {
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
            }
          }
      }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
          let location = touch.location(in: self)
          let touchedNode = self.nodes(at: location)
          for node in touchedNode {
//              if node.name == "play_button" {
//                  startGame()
//              }
            if node.name == "left" {
                
                player.position.x -= 25
                
            }
            if node.name == "right" {
              player.position.x += 25
            }
          }
          }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    func addMonster() {
        // Create sprite
         let thunder = SKSpriteNode(imageNamed: "image/thunder")
        thunder.size = CGSize(width: 50, height: 50)
         // Determine where to spawn the monster along the Y axis
         let actualX = random(min: thunder.size.height/2, max: size.height - thunder.size.height/2)
         
         // Position the monster slightly off-screen along the right edge,
         // and along a random position along the Y axis as calculated above
         thunder.position = CGPoint(x: actualX, y: size.width + thunder.size.width/2)
         
         // Add the monster to the scene
         addChild(thunder)
         
         // Determine speed of the monster
         let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
         
         // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -thunder.size.width),
                                        duration: TimeInterval(actualDuration))
         let actionMoveDone = SKAction.removeFromParent()
         thunder.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
