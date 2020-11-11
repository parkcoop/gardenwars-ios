import SpriteKit
import AudioToolbox


enum CollisionTypes: UInt32 {
    case player = 1
    case soil = 2
    case thunder = 4
    case sun = 8
    case water = 16
}

class Gameplay: SKScene, SKPhysicsContactDelegate {
    private var activeTouches = [UITouch:String]()
    let controls = UIControls()
    let gameSetting = Level()
    var player1 = Player()
    var hpDisplay = HealthPoints()

    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        buildLevel1()
        
        
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(gameSetting.addThunder),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(gameSetting.addSun),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(gameSetting.addWater),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name != nil && contact.bodyB.node?.name != nil) {
            
            print(contact.bodyA.node!.name!, contact.bodyB.node!.name!)
            
            // Replenish soil (player <-> soil)
            if (contact.bodyA.node!.name! == "player") || (contact.bodyA.node!.name! == "soil")
                && (contact.bodyB.node!.name! == "soil") || (contact.bodyB.node!.name! == "player") {
                if (player1.currentItem == "sun" || player1.currentItem == "water") {
                    if gameSetting.replenishSoil(flower: contact.bodyA.node!) {
                        player1.garden()
                    }
                }
            }
//            // Hold item (player <-> water || sun)
//            if (((contact.bodyA.node!.name! == "player") || (contact.bodyA.node!.name! == "sun"))
//                    && ((contact.bodyB.node!.name! == "sun") || (contact.bodyB.node!.name! == "player"))
//                || ((contact.bodyA.node!.name! == "player") || (contact.bodyA.node!.name! == "water"))
//                    && ((contact.bodyB.node!.name! == "water") || (contact.bodyB.node!.name! == "player"))) {
//               //code
//                print("GRABBBINN")
//                if player1.holdItem(item: contact.bodyA.node!.name!) {
//                    if contact.bodyA.node!.name! == "water" {
//                        gameSetting.water.removeAllActions()
//                        gameSetting.water.position = CGPoint(x: 0, y: -200)
//                    } else if contact.bodyA.node!.name! == "sun" {
//                        gameSetting.sun.removeAllActions()
//                        gameSetting.sun.position = CGPoint(x: 0, y: -200)
//                    }
//                }
//            }
         
            
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        hpDisplay.healthText.text = String(player1.health)
        hpDisplay.scoreText.text = String(player1.points)
        if (controls.xDist < 0) {
            player1.position.x -= 0.2 * controls.xDist
        } else if (controls.xDist > 0) {
            player1.position.x -= 0.2 * controls.xDist
        } else {
            player1.faceForward()
        }
        
        if player1.frame.intersects(gameSetting.thunder.frame) {
            player1.takeDamage(points: 10)
            gameSetting.thunder.removeAllActions()
            gameSetting.thunder.position = CGPoint(x: 0, y: -200)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if player1.frame.intersects(gameSetting.water.frame) {
            if player1.holdItem(item: "water") {
                gameSetting.water.removeAllActions()
                gameSetting.water.position = CGPoint(x: 0, y: -200)
            }
           
        }
        if player1.frame.intersects(gameSetting.sun.frame) {
            if player1.holdItem(item: "sun") {
                gameSetting.sun.removeAllActions()
                gameSetting.sun.position = CGPoint(x: 0, y: -200)
            }
          
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "jump" {
                    activeTouches[touch] = "jump"
                    tapBegin(on: "jump")
                }
            }
            if (controls.substrate.frame.contains(location)) {
                activeTouches[touch] = "joystick"
                tapBegin(on: "joystick")
                controls.stickActive = true
            } else {
                controls.stickActive = false
            }
            
           
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (controls.substrate.frame.contains(location)) {
                controls.joyStickPoint = location
                tapContinues(on: "joystick")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let touchedArea = activeTouches[touch] else { break }
            activeTouches[touch] = nil
            tapEnd(on: touchedArea)
        }
    }
    
    private func tapBegin(on button: String) {
        if (button == "jump") {
            player1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
       }
    
    private func tapContinues(on button: String) {
        if (button == "joystick") {
            controls.moveJoystick()
            
            if (controls.xDist < 0) {
                player1.walkRight()
            } else if (controls.xDist > 0) {
                player1.walkLeft()
            } else {
                player1.faceForward()
            }
       }

    }

       private func tapEnd(on button:String) {
        if (button == "joystick") {
            controls.xDist = 0
            controls.stickActive = false
            let move:SKAction = SKAction.move(to: controls.substrate.position, duration: 0.2)
                move.timingMode = .easeOut
            controls.stick.run(move)
        }
       }
    
    
    func buildLevel1() {

        addChild(gameSetting)
        addChild(controls)
        controls.build()
        gameSetting.buildLevel1()
        addChild(hpDisplay)
        
        
        player1.buildPlayer1()
        hpDisplay.build()
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.soil.rawValue
        player1.name = "player"
        addChild(player1)

        gameSetting.soil.physicsBody?.categoryBitMask = CollisionTypes.soil.rawValue
        gameSetting.soil.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue

        gameSetting.sun.physicsBody?.categoryBitMask = CollisionTypes.sun.rawValue
        gameSetting.sun.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
        gameSetting.water.physicsBody?.categoryBitMask = CollisionTypes.water.rawValue
        gameSetting.water.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
    }
    
    

    



}
