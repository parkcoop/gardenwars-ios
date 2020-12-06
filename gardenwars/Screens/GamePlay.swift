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
    var settingsMenu = PauseScreenOverlay()
    
    var entityManager: EntityManager!
    var enemyStateMachine: GKStateMachine!
    
    let agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    
    var lastUpdateTimeInterval: TimeInterval = 0
    
    
    let humanGardener = Gardener(imageName: "image/\(chosenCharacter)5", team: .team1)
    let aiGardener = EnemyGardener(imageName: "image/\(enemyCharacter)5", team: .team2)
    
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
        //        view.showsPhysics = true
        if let enemySprite = aiGardener.component(ofType: SpriteComponent.self) {
            if let hpBar = aiGardener.component(ofType: HPSpriteBar.self) {
                if let coinBar = aiGardener.component(ofType: EnemyCoinDisplayComponent.self) {
                    
                    addChild(hpBar.container)
                    addChild(coinBar.container)
                    
                    //                hpBar.container.position = CGPoint(x: 100, y: 200)
                    
                    // Constrain the shadow node's position to the render node.
                    let xRange = SKRange(constantValue: hpBar.container.position.x)
                    let lowerYRange = SKRange(constantValue: hpBar.container.position.y + 50)
                    let upperYRange = SKRange(constantValue: coinBar.container.position.y + 60)
                    
                    let hpConstraint = SKConstraint.positionX(xRange, y: lowerYRange)
                    hpConstraint.referenceNode = enemySprite.node
                    
                    hpBar.container.constraints = [hpConstraint]
                    
                    let coinConstraint = SKConstraint.positionX(xRange, y: upperYRange)
                    coinConstraint.referenceNode = enemySprite.node
                    
                    coinBar.container.constraints = [coinConstraint]
                }
            }
        }
        
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
        
        soil1.position = CGPoint(x: platformLeft!.position.x, y: platformLeft!.position.y  + platformLeft!.frame.size.width / 2)
        soil1.zPosition = 500
        addChild(soil1)
        
        soil2.position = platformRight!.position
        soil2.position = CGPoint(x: platformRight!.position.x, y: platformRight!.position.y  + platformRight!.frame.size.width / 2)
        soil2.zPosition = 500
        addChild(soil2)
        
        soil3.position = platform!.position
        soil3.position = CGPoint(x: platform!.position.x, y: platform!.position.y + platform!.frame.size.width / 2)
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
        
        
        let background: SKSpriteNode
        if currentLevel == 1 {
            background = SKSpriteNode(imageNamed: "image/sky")
        } else if currentLevel == 2 {
            background = SKSpriteNode(imageNamed: "image/forest")
        } else {
            background = SKSpriteNode(imageNamed: "image/sunset")
        }
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        addChild(background)
        
        let settingsNode = SKSpriteNode(imageNamed: "image/settings")
        settingsNode.position = CGPoint(x: ScreenSize.width - 50, y: ScreenSize.height - 50)
        settingsNode.scale(to: CGSize(width: 25, height: 25))
        settingsNode.name = "settings"
        addChild(settingsNode)
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
                SKAction.run({self.determineSoilPatchForAgent()})
            ])
        ))
    }
    var lastSequencePosition = CGPoint(x: 0, y: 0)
    func checkStall() {
        guard let enemySprite = aiGardener.component(ofType: SpriteComponent.self) else {
            fatalError("Enemy needs a sprite")
        }
        
        if (lastSequencePosition.x > enemySprite.node.position.x - 25),
           (lastSequencePosition.x < enemySprite.node.position.x + 25) {
            changeCurrentItemGoal(item: "sun")
        } else {
            lastSequencePosition = enemySprite.node.position
        }
        
    }
    
    
    
    func changeCurrentItemGoal(item: String) {
        
        let obstacles = SKNode.obstacles(fromNodePhysicsBodies: [
            self.childNode(withName: "platformLeft")!,
            self.childNode(withName: "platformRight")!
        ])
        
        
        let obtainSunGoal = GKGoal(toInterceptAgent: sunAgent, maxPredictionTime: Double(enemyPredictionTime))
        let obtainWaterGoal = GKGoal(toInterceptAgent: waterAgent, maxPredictionTime: Double(enemyPredictionTime))
        //        let avoidShockGoal = GKGoal(toAvoid: [thunderAgent], maxPredictionTime: 5)
        let avoidObstaclesGoal = GKGoal(toAvoid: obstacles, maxPredictionTime: Double(enemyPredictionTime))
        
        var goals: [GKGoal] = []
        
        switch item {
        case "sun":
            goals = [obtainSunGoal, avoidObstaclesGoal]
        case "water":
            goals = [obtainWaterGoal, avoidObstaclesGoal]
        default:
            goals = []
        }
        
        var aiControlComponent: EnemyAgentComponent? {
            return aiGardener.component(ofType: EnemyAgentComponent.self)
        }
        if (enemyPredictionTime > 5) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                aiControlComponent?.setUpAgent(with: goals)
            }
        } else {
            aiControlComponent?.setUpAgent(with: goals)
        }
    }
    
    func determineSoilPatchForAgent() {
        
        let obstacles = SKNode.obstacles(fromNodePhysicsBodies: [
            self.childNode(withName: "platformLeft")!,
            self.childNode(withName: "platformRight")!
        ])
        
        let gardeningGoal: GKGoal
        
        if (soil1.growthPhase > 6) {
            gardeningGoal = GKGoal(toSeekAgent: soil1Agent)
        } else if (soil2.growthPhase > 6) {
            gardeningGoal = GKGoal(toSeekAgent: soil2Agent)
        } else {
            gardeningGoal = GKGoal(toSeekAgent: soil3Agent)
        }
        
        let avoidObstaclesGoal = GKGoal(toAvoid: obstacles, maxPredictionTime: Double(enemyPredictionTime))
        
        var goals: [GKGoal] = [gardeningGoal, avoidObstaclesGoal]
        var aiControlComponent: EnemyAgentComponent? {
            return aiGardener.component(ofType: EnemyAgentComponent.self)
        }
        
        aiControlComponent?.setUpAgent(with: goals)
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
        //        adjustGoalsBasedOnState()
        
        sunAgent.position = SIMD2<Float>(Float((sun.position.x)), Float((sun.position.y)))
        thunderAgent.position = SIMD2<Float>(Float((thunder.position.x)), Float((thunder.position.y)))
        waterAgent.position = SIMD2<Float>(Float((water.position.x)), Float((water.position.y)))
        //        print(sun.position, sunAgent.position)
        
        
        if let human = entityManager.gardener(for: .team1),
           let humanGardener = human.component(ofType: GardenerComponent.self) {
            hpDisplay.healthText.text = String(humanGardener.health)
            hpDisplay.scoreText.text = String(humanGardener.points)
            if (humanGardener.points >= 100) {
                currentLevel += 1
                player1Wins += 1
                nextLevel(nextLevel: currentLevel)
            }
            
        }
        aiGardener.update(deltaTime: deltaTime)
        if let ai = entityManager.gardener(for: .team2),
           let aiGardener = ai.component(ofType: GardenerComponent.self) {
            
            //            if let enemyHpBar = ai.component(ofType: HPSpriteBar.self) {
            //                enemyHpBar.setProgress(CGFloat(aiGardener.health))
            //            }
            
            if (aiGardener.points >= 100) {
                currentLevel += 1
                player2Wins += 1
                nextLevel(nextLevel: currentLevel)
            }
            
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
    
    func nextLevel(nextLevel: Int) {
        switch nextLevel {
        case 2:
            GameManager.shared.transition(self, toScene: .Level2, transition:
                                            SKTransition.push(with: SKTransitionDirection.left, duration: 1))
        case 3:
            GameManager.shared.transition(self, toScene: .Level3, transition:
                                            SKTransition.fade(with: UIColor.black, duration: 1))
        default:
            GameManager.shared.transition(self, toScene: .GameOver, transition:
                                            SKTransition.fade(with: UIColor.black, duration: 1))
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
            component.physicsBody.applyImpulse(CGVector(dx: 0, dy: 25))
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
        if self.view!.scene?.isPaused == true {
            self.view!.scene?.isPaused = false
            settingsMenu.removeFromParent()
            return
        }
        self.view!.scene?.isPaused = true
        //        loadPauseBGScreen()
        settingsMenu.zPosition = 5000000
        addChild(settingsMenu)
        
        //        GameManager.shared.transition(self, toScene: .MainMenu, transition:
        //                                        SKTransition.doorsCloseHorizontal(withDuration: 2))
    }
    //    func getBluredScreenshot() -> SKSpriteNode{
    //
    ////        create the graphics context
    //        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.scene!.view!.frame.size.width, height: self.scene!.view!.frame.size.height), true, 1)
    //
    //        self.scene!.view!.drawHierarchy(in: self.scene!.view!.frame, afterScreenUpdates: true)
    //
    //        // retrieve graphics context
    //        let context = UIGraphicsGetCurrentContext()
    //
    //        // query image from it
    //        let image = UIGraphicsGetImageFromCurrentImageContext()
    //
    //        // create Core Image context
    //        let ciContext = CIContext(options: nil)
    //        // create a CIImage, think of a CIImage as image data for processing, nothing is displayed or can be displayed at this point
    //        let coreImage = CIImage(image: image!)
    //        // pick the filter we want
    //        let filter = CIFilter(name: "CIGaussianBlur")
    //        // pass our image as input
    //        filter!.setValue(coreImage, forKey: kCIInputImageKey)
    //
    //        //edit the amount of blur
    //        filter!.setValue(3, forKey: kCIInputRadiusKey)
    //
    //        //retrieve the processed image
    //        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
    //        // return a Quartz image from the Core Image context
    ////        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
    //        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    //        // final UIImage
    //        let filteredImage = UIImage(cgImage: filteredImageRef!)
    //
    //        // create a texture, pass the UIImage
    //        let texture = SKTexture(image: filteredImage)
    //        // wrap it inside a sprite node
    //        let sprite = SKSpriteNode(texture:texture)
    //
    //        // make image the position in the center
    ////        sprite.position = CGPoint(x: CGRect.midX(self.scene!.frame.midX), y: CGRect.midX(self.scene!.frame.midY))
    //
    ////        var scale:CGFloat = UIScreen.mainScreen().scale
    ////
    ////        sprite.size.width  *= scale
    ////
    ////        sprite.size.height *= scale
    //
    //        return sprite
    //
    //
    //    }
    //
    //
    //    func loadPauseBGScreen(){
    //
    //        let duration = 1.0
    //
    //        let pauseBG:SKSpriteNode = self.getBluredScreenshot()
    //
    //        //pauseBG.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    //        pauseBG.alpha = 0
    //        pauseBG.zPosition = self.zPosition + 1
    //        pauseBG.run(SKAction.fadeAlpha(to: 1, duration: duration))
    //
    //        self.addChild(pauseBG)
    //
    //    }
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
