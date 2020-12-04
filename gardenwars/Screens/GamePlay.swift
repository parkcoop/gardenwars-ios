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

class GamePlay: SKScene, SKPhysicsContactDelegate {
    
    
    private var activeTouches = [UITouch:String]()
    let uiControls = UIControls()
//    let gameSetting = GameSetting()
    
    var hpDisplay = HealthPoints()
    var settingsToggle = SKSpriteNode(imageNamed: "image/settings")
    
    
    var entityManager: EntityManager!
    var enemyStateMachine: GKStateMachine!
    
    let agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    
    var lastUpdateTimeInterval: TimeInterval = 0

    
    let humanGardener = Gardener(imageName: "image/parker5", team: .team1)
    let aiGardener = EnemyGardener(imageName: "image/parker5", team: .team2)

    let thunder = SKSpriteNode(imageNamed: "image/thunder")
    let sun = SKSpriteNode(imageNamed: "image/sun")
    let water = SKSpriteNode(imageNamed: "image/water")
    let waterAgent = GKAgent2D()
    let sunAgent = GKAgent2D()
    let thunderAgent = GKAgent2D()
    
    let soil1 = Flower(named: "soil1")
    let soil2 = Flower(named: "soil2")
    let soil3 = Flower(named: "soil3")
    
    let soil1Agent = GKAgent2D()
    let soil2Agent = GKAgent2D()
    let soil3Agent = GKAgent2D()
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        view.showsDrawCount = true
        view.showsPhysics = true
        

        guard let humanAgent = humanGardener.component(ofType: MovementComponent.self)?.playerAgent else {
            fatalError()
        }
        self.agentSystem.addComponent(humanAgent)
        
        
        sun.name = "sun"
        addChild(sun)
        water.name = "water"
        addChild(water)
        thunder.name = "thunder"
        addChild(thunder)
        let platformLeft = self.childNode(withName: "platformLeft")
        let platformRight = self.childNode(withName: "platformRight")
        let platform = self.childNode(withName: "platform")

        soil1.position = CGPoint(x: platformLeft!.position.x, y: platformLeft!.position.y + 83)
        soil1.zPosition = 500
        addChild(soil1)
        
        soil2.position = platformRight!.position
        soil2.position = CGPoint(x: platformRight!.position.x, y: platformRight!.position.y + 83)
        soil2.zPosition = 500
        addChild(soil2)
        
        soil3.position = platform!.position
        soil3.position = CGPoint(x: platform!.position.x, y: platform!.position.y + 83)
        soil3.zPosition = 500
        addChild(soil3)
//        let soil1 = self.childNode(withName: "soil1")
        soil1Agent.position = SIMD2<Float>(Float((soil1.position.x)), Float((soil1.position.y)))
//        soil1Agent.accessibilityFrame = CGRect.init(x: Double(soil1Agent.position.x), y: Double(soil1Agent.position.y), width: 50, height: 50)
//        let soil2 = self.childNode(withName: "soil2")
        soil2Agent.position = SIMD2<Float>(Float((soil2.position.x)), Float((soil2.position.y)))
//        let soil3 = self.childNode(withName: "soil3")
        soil3Agent.position = SIMD2<Float>(Float((soil3.position.x)), Float((soil3.position.y)))
        
        
        enemyStateMachine = GKStateMachine(states: [
            NormalState(game: self),
            HoldingItemState(game: self)
        ])
        
        enemyStateMachine.enter(NormalState.self)

        var aiControlComponent: EnemyAgentComponent? {
            return aiGardener.component(ofType: EnemyAgentComponent.self)
        }
        
        
        
        let agent = aiControlComponent?.setUpAgent(with: [])
        self.agentSystem.addComponent(agent!)
        
        entityManager = EntityManager(scene: self)
        
        if let playerGardener = humanGardener.component(ofType: SpriteComponent.self) {
            playerGardener.node.position = CGPoint(x: playerGardener.node.size.width, y: size.height/2)
        }
        entityManager.add(humanGardener)
        
        if let enemyGardener = aiGardener.component(ofType: SpriteComponent.self) {
            enemyGardener.node.position = CGPoint(x: size.width - enemyGardener.node.size.width, y: size.height/2)
        }
        entityManager.add(aiGardener)
        
        
        
        
        let background = SKSpriteNode(imageNamed: "image/sky")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        addChild(background)

        
        addChild(uiControls)
        addChild(hpDisplay)
        
        if let humanGardener = humanGardener.component(ofType: GardenerComponent.self) {
            humanGardener.initGame(game: self)
            
        }
           
        if let aiGardener = aiGardener.component(ofType: GardenerComponent.self) {
            aiGardener.initGame(game: self)
            
        }
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addThunder),
                SKAction.wait(forDuration: 3.0),
                SKAction.run(addWater),
                SKAction.run({self.changeCurrentItemGoal(item: "water")}),
                SKAction.run(addThunder),
                SKAction.wait(forDuration: 3.0),
                SKAction.run(addSun),
                SKAction.run({self.changeCurrentItemGoal(item: "sun")}),
                SKAction.run(addThunder),
                SKAction.wait(forDuration: 3.0),
            ])
        ))
    }
    
    
//    func garden(flower: Flower) {
////        if let flowerComponent = flower.entity!.component(ofType: FlowerComponent.self) {
////            flowerComponent.replenishSoil()
////        }
//    }
    
    func changeCurrentItemGoal(item: String) {
        
        let obstacles = SKNode.obstacles(fromNodePhysicsBodies: [
            self.childNode(withName: "platformLeft")!,
            self.childNode(withName: "platformRight")!
        ])
        
        
        let obtainSunGoal = GKGoal(toSeekAgent: sunAgent)
        let obtainWaterGoal = GKGoal(toSeekAgent: waterAgent)
//        let avoidShockGoal = GKGoal(toAvoid: [thunderAgent], maxPredictionTime: 5)
        let avoidObstaclesGoal = GKGoal(toAvoid: obstacles, maxPredictionTime: 1)

        var goals: [GKGoal] = []
        
        switch item {
        case "sun":
            goals = [obtainSunGoal, avoidObstaclesGoal]
        case "water":
            goals = [obtainWaterGoal, avoidObstaclesGoal]
        default:
            print("Need to specify item")
        }
 
        var aiControlComponent: EnemyAgentComponent? {
            return aiGardener.component(ofType: EnemyAgentComponent.self)
        }

        aiControlComponent?.setUpAgent(with: goals)
//        self.agentSystem.addComponent(agent!)
    }
    
    func adjustGoalsBasedOnState(state: AnyClass) -> [GKGoal] {
        switch state {
        case is NormalState.Type:
            print("GET SOME")
        case is HoldingItemState.Type:
            print("WE ALRDY GOT SOME")
        default:
            print("?")
        }
        return []
    }
    
    
    func addThunder() -> Void {
        if childNode(withName: "thunder") === nil {
            self.addChild(thunder)
            agentSystem.addComponent(thunderAgent)
        }
        let actualX = CGFloat.random(in: 0...ScreenSize.width)
        let actualDuration = CGFloat.random(in: CGFloat(1.0)...CGFloat(3.0))
        thunder.size = CGSize(width: 50, height: 50)
        thunder.position = CGPoint(x: actualX, y: ScreenSize.height)
        thunder.zPosition = 50000
        thunder.name = "thunder"
        thunder.position = CGPoint(x: actualX, y: 555 + thunder.size.width/2)
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -50),
                                       duration: TimeInterval(actualDuration))
        thunder.run(actionMove)
    }
    func addSun() -> Void {
        if childNode(withName: "sun") === nil {
            self.addChild(sun)
            agentSystem.addComponent(sunAgent)

        }
        let actualX = CGFloat.random(in: 0...ScreenSize.width)
        sun.size = CGSize(width: 50, height: 50)
        sun.name = "sun"
        sun.physicsBody = SKPhysicsBody(rectangleOf: sun.size)
        sun.physicsBody!.categoryBitMask = UInt32(1)
        sun.physicsBody!.collisionBitMask = UInt32(2)
        sun.physicsBody!.contactTestBitMask = UInt32(3)
        sun.position = CGPoint(x: actualX, y: 555 + sun.size.width/2)
        sun.zPosition = 50000
    }
    func addWater() -> Void {
        if childNode(withName: "water") === nil {
            self.addChild(water)
            agentSystem.addComponent(waterAgent)

        }
        let actualX = CGFloat.random(in: 0...ScreenSize.width)
        water.name = "water"
        water.size = CGSize(width: 50, height: 50)
        water.position = CGPoint(x: actualX, y: 555 + water.size.width/2)
        water.physicsBody = SKPhysicsBody(rectangleOf: water.size)
        water.physicsBody!.categoryBitMask = UInt32(1)
        water.physicsBody!.collisionBitMask = UInt32(2)
        water.physicsBody!.contactTestBitMask = UInt32(3)
        water.position = CGPoint(x: actualX, y: 555 + water.size.width/2)
        water.zPosition = 50000
    }

    
    // MARK: Update loop function
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        entityManager.update(deltaTime)
        
        agentSystem.update(deltaTime: deltaTime)
        enemyStateMachine.update(deltaTime: deltaTime)
        
        sunAgent.position = SIMD2<Float>(Float((sun.position.x)), Float((sun.position.y)))
        thunderAgent.position = SIMD2<Float>(Float((thunder.position.x)), Float((thunder.position.y)))
        waterAgent.position = SIMD2<Float>(Float((water.position.x)), Float((water.position.y)))
//        print(sun.position, sunAgent.position)
        
        
        if let human = entityManager.gardener(for: .team1),
           let humanGardener = human.component(ofType: GardenerComponent.self) {
            hpDisplay.healthText.text = String(humanGardener.health)
            hpDisplay.scoreText.text = String(humanGardener.points)
            
        }
//////////////////        HP BAR UPDATE...
//        if let ai = entityManager.gardener(for: .team2),
//           let aiGardener = ai.component(ofType: GardenerComponent.self) {
////            hpDisplay.healthText.text = String(aiGardener.health)
////            hpDisplay.scoreText.text = String(aiGardener.points)
//
//        }
        
        // MARK: Joystick controls for player
        if let component = humanGardener.component(ofType: SpriteComponent.self) {
            if (uiControls.xDist < 0) {
                component.node.position.x -= 0.2 * uiControls.xDist
            } else if (uiControls.xDist > 0) {
                component.node.position.x -= 0.2 * uiControls.xDist
            }
            
        }
        

        
        
    }

    // MARK: Touch controls: Joystick, jump button, settings screen
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
            if (uiControls.substrate.frame.contains(location)) {
                activeTouches[touch] = "joystick"
                tapBegin(on: "joystick")
                uiControls.stickActive = true
            } else {
                uiControls.stickActive = false
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (uiControls.substrate.frame.contains(location)) {
                uiControls.joyStickPoint = location
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
        if (button == "jump"),
           let component = humanGardener.component(ofType: PhysicsComponent.self) {
                component.physicsBody.velocity = CGVector(dx: 0, dy: 0)
                component.physicsBody.applyImpulse(CGVector(dx: 0, dy: 100))
            }
        
    }
    
    
    private func tapContinues(on button: String) {
        if (button == "joystick") {
            uiControls.moveJoystick()
            if let component = humanGardener.component(ofType: MovementComponent.self) {
                if (uiControls.xDist < 0) {
                    component.move(direction: "right")
                } else if (uiControls.xDist > 0) {
                    component.move(direction: "left")
                } else {
                    component.faceForward()
                }
            }
            
        }
        
    }
    
    
    private func tapEnd(on button:String) {
        if (button == "joystick") {
            uiControls.xDist = 0
            uiControls.stickActive = false
            let move:SKAction = SKAction.move(to: uiControls.substrate.position, duration: 0.2)
            move.timingMode = .easeOut
            uiControls.stick.run(move)
            if let component = humanGardener.component(ofType: MovementComponent.self) {
                component.faceForward()
            }
        }
    }
    
    
    
    
    func openSettingsMenu() -> Void {
        GameManager.shared.transition(self, toScene: .MainMenu, transition:
                                        SKTransition.doorsCloseHorizontal(withDuration: 2))
    }
//
//    func nextLevel(level: Int) -> Void {
//        switch level {
//        case 2:
//            gameSetting.buildLevel2()
//        case 3:
//            gameSetting.buildLevel3()
//        case 4: // Ended game
//            GameManager.shared.transition(self, toScene: .Settings, transition:
//                                            SKTransition.crossFade(withDuration: 2))
//        default:
//            return
//        }
//    }
//
    
    
    
    
}
