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
    var player1 = Player(textureAtlas: "parker")
    var enemy = Player(textureAtlas: "parker")
    var hpDisplay = HealthPoints()
    var settingsToggle = SKSpriteNode(imageNamed: "image/settings")
    var currentLevel = 1
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        initializePhysicsBodies()
        settingsToggle.position = CGPoint(x: ScreenSize.width * 0.9, y: ScreenSize.height * 0.9)
        settingsToggle.scale(to: CGSize(width: 50, height: 50))
        settingsToggle.name = "settings"
        addChild(settingsToggle)
        
        
        weak var weakSelf = self // ARC?
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({weakSelf!.gameSetting.skyFall(item: weakSelf!.gameSetting.thunder)}),
                SKAction.wait(forDuration: 1.0),
                SKAction.run({weakSelf!.gameSetting.skyFall(item: weakSelf!.gameSetting.sun)}),
                SKAction.run({self.moveEnemy(desiredItem: weakSelf!.gameSetting.sun)}),
                SKAction.wait(forDuration: 1.0),
                SKAction.run({weakSelf!.gameSetting.skyFall(item: weakSelf!.gameSetting.water)}),
                SKAction.run({self.moveEnemy(desiredItem: weakSelf!.gameSetting.water)}),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name != nil && contact.bodyB.node?.name != nil) {
            
            // Replenish soil (player <-> soil)
            if (contact.bodyA.node!.name! == "player") || (contact.bodyA.node!.name! == "soil")
                && (contact.bodyB.node!.name! == "soil") || (contact.bodyB.node!.name! == "player") {
                if (player1.currentItem == "sun" || player1.currentItem == "water") {
                    if gameSetting.replenishSoil(flower: contact.bodyA.node!) {
                        player1.garden()
                    }
                }
            }
            // Replenish soil (player <-> soil)
            if (contact.bodyA.node!.name! == "enemy") || (contact.bodyA.node!.name! == "soil")
                && (contact.bodyB.node!.name! == "soil") || (contact.bodyB.node!.name! == "enemy") {
                if (enemy.currentItem == "sun" || enemy.currentItem == "water") {
                    if gameSetting.replenishSoil(flower: contact.bodyA.node!) {
                        enemy.garden()
                    }
                }
            }
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
        enemy.faceForward()
        
        
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
        
        
        if enemy.frame.intersects(gameSetting.thunder.frame) {
            enemy.takeDamage(points: 10)
            gameSetting.thunder.removeAllActions()
            gameSetting.thunder.position = CGPoint(x: 0, y: -200)
        }
        if enemy.frame.intersects(gameSetting.water.frame) {
            if enemy.holdItem(item: "water") {
                gameSetting.water.removeAllActions()
                gameSetting.water.position = CGPoint(x: 0, y: -200)
            }
        }
        if enemy.frame.intersects(gameSetting.sun.frame) {
            if enemy.holdItem(item: "sun") {
                gameSetting.sun.removeAllActions()
                gameSetting.sun.position = CGPoint(x: 0, y: -200)
            }
        }
        
        
        if (player1.points >= 100) || (enemy.points >= 100) {
            player1.points = 0
            enemy.points = 0
            gameSetting.removeAllChildren()
            
            nextLevel(level: currentLevel + 1)
            currentLevel += 1
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
                if node.name == "settings" {
                    openSettingsMenu()
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
    
    
    func initializePhysicsBodies() {
        
        addChild(gameSetting)
        addChild(controls)
        gameSetting.buildLevel1()
        addChild(hpDisplay)
        
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.soil.rawValue
        player1.name = "player"
        addChild(player1)
        
        enemy.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        enemy.physicsBody?.contactTestBitMask = CollisionTypes.soil.rawValue
        enemy.name = "enemy"
        addChild(enemy)
        
        gameSetting.soil.physicsBody?.categoryBitMask = CollisionTypes.soil.rawValue
        gameSetting.soil.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        gameSetting.sun.physicsBody?.collisionBitMask = CollisionTypes.player.rawValue 
//        gameSetting.sun.physicsBody?.categoryBitMask = CollisionTypes.sun.rawValue
//        gameSetting.sun.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
//
//        gameSetting.water.physicsBody?.categoryBitMask = CollisionTypes.water.rawValue
//        gameSetting.water.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
    }
    
    
    func moveEnemy(desiredItem: SKSpriteNode) {
        enemy.run(SKAction.moveTo(x: desiredItem.position.x, duration: 2))
        if enemy.currentItem != "" {
            if (gameSetting.soil.growthPhase < 6) {
                enemy.run(SKAction.moveTo(x: gameSetting.soil.position.x, duration: 2))
                if gameSetting.soil.replenishSoil() {
                    return enemy.garden()
                }            }
            if (gameSetting.soil2.growthPhase < 6) {
                enemy.run(SKAction.moveTo(x: gameSetting.soil2.position.x, duration: 2))
                if gameSetting.soil2.replenishSoil() {
                    return enemy.garden()
                }
            }
            if (gameSetting.soil3.growthPhase < 6) {
                enemy.run(SKAction.moveTo(x: gameSetting.soil3.position.x, duration: 2))
                if gameSetting.soil3.replenishSoil() {
                    return enemy.garden()
                }            }
        }
//        enemy.faceForward()

    }
    
    
    func openSettingsMenu() -> Void {
        GameManager.shared.transition(self, toScene: .MainMenu, transition:
                                        SKTransition.doorsCloseHorizontal(withDuration: 2))
    }
    
    func nextLevel(level: Int) -> Void {
        switch level {
        case 2:
            gameSetting.buildLevel2()
        case 3:
            gameSetting.buildLevel3()
        case 4: // Ended game
            GameManager.shared.transition(self, toScene: .Settings, transition:
                                            SKTransition.crossFade(withDuration: 2))
        default:
            return
        }
    }
    
    
    
    
    
}
