import SpriteKit
import AudioToolbox
import GameplayKit

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

    var hpDisplay = HealthPoints()
    var settingsToggle = SKSpriteNode(imageNamed: "image/settings")
    
    
    var entityManager: EntityManager!
    
    
    var lastUpdateTimeInterval: TimeInterval = 0
    
    let coin1Label = SKLabelNode(fontNamed: "Courier-Bold")
    let coin2Label = SKLabelNode(fontNamed: "Courier-Bold")
    
    let humanGardener = Gardener(imageName: "image/parker5", team: .team1)
    let aiGardener = Gardener(imageName: "image/parker5", team: .team2)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        addChild(controls)
        addChild(hpDisplay)
        gameSetting.buildLevel1()
        addChild(gameSetting)
        let background = SKSpriteNode(imageNamed: "image/sky")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        addChild(background)
        
        coin1Label.position = CGPoint(x: 100, y: ScreenSize.height - 50)
        self.addChild(coin1Label)
        
        coin2Label.position = CGPoint(x: ScreenSize.width - 100, y: ScreenSize.height - 50)
        self.addChild(coin2Label)
        // 1
        entityManager = EntityManager(scene: self)

        // 2
        if let spriteComponent = humanGardener.component(ofType: SpriteComponent.self) {
          spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width, y: size.height/2)
        }
        entityManager.add(humanGardener)

        // 3
        if let spriteComponent = aiGardener.component(ofType: SpriteComponent.self) {
          spriteComponent.node.position = CGPoint(x: size.width - spriteComponent.node.size.width, y: size.height/2)
        }
        entityManager.add(aiGardener)
        
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.wait(forDuration: 1.0),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name != nil && contact.bodyB.node?.name != nil) {

        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime

        entityManager.update(deltaTime)

        if let human = entityManager.gardener(for: .team1),
          let humanGardener = human.component(ofType: GardenerComponent.self) {
          coin1Label.text = "\(humanGardener.coins)"
        }
        if let ai = entityManager.gardener(for: .team2),
          let aiGardener = ai.component(ofType: GardenerComponent.self) {
          coin2Label.text = "\(aiGardener.coins)"
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("LOL")
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
//            player1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//            player1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            if let component = humanGardener.component(ofType: MovementComponent.self) {
//                component.jump()
                component.jump()
            }
        }
    }
    
    
    private func tapContinues(on button: String) {
        if (button == "joystick") {
            controls.moveJoystick()
            if let component = humanGardener.component(ofType: MovementComponent.self) {
                if (controls.xDist < 0) {
                    component.move(direction: "right")
                } else if (controls.xDist > 0) {
                    component.move(direction: "left")
                } else {
                    component.faceForward()
                }
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
