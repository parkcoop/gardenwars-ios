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
    let gameSetting = GameSetting()

    var hpDisplay = HealthPoints()
    var settingsToggle = SKSpriteNode(imageNamed: "image/settings")
    
    
    var entityManager: EntityManager!
    
    let agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)

    var lastUpdateTimeInterval: TimeInterval = 0
    
    let coin1Label = SKLabelNode(fontNamed: "Courier-Bold")
    let coin2Label = SKLabelNode(fontNamed: "Courier-Bold")
    
    let humanGardener = Gardener(imageName: "image/parker5", team: .team1)
    let aiGardener = Gardener(imageName: "image/parker5", team: .team2)
    
    var navigationGraph: GKGraph!

    
    let spawnPoints = [
            CGPoint(x: 245, y: 3900),
            CGPoint(x: 700, y: 3500),
            CGPoint(x: 1250, y: 1500),
            CGPoint(x: 1200, y: 1950),
            CGPoint(x: 1200, y: 2450),
            CGPoint(x: 1200, y: 2950),
            CGPoint(x: 1200, y: 3400),
            CGPoint(x: 2550, y: 2350),
            CGPoint(x: 2500, y: 3100),
            CGPoint(x: 3000, y: 2400),
            CGPoint(x: 2048, y: 2400),
            CGPoint(x: 2200, y: 2200)
        ]
    var graph: GKObstacleGraph<GKGraphNode2D>!
    
    
    
    override func didMove(to view: SKView) {
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        navigationGraph = self.graph

        print("THE GRAPH", self.graph)
        
        
        
        let sceneFile = "GamePlay"
         if let gkScene = GKScene( fileNamed: sceneFile ) {
            navigationGraph = gkScene.graphs["enemypath"]!
            
            print( "graphs = \(gkScene.graphs["enemypath"])" )
         } else {
             print( "failed to create gkScene from file \(sceneFile)" )
         }
        
        print("WHAT ABOUT NOW?", navigationGraph!)
        
       
        
//        let obstacles = SKNode.obstacles(fromNodePhysicsBodies: gameSetting.children)
//        graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 100)
//        print("OBBSTACLES", graph)
      
        let newGraph = GKGraph()
        for drawnNode in navigationGraph.nodes! {
            let coordinatePoint = SKSpriteNode(color: .blue, size: CGSize(width: 5, height: 5))
//            coordinatePoint.position = drawnNode[0]
//            self.addChild(position)
            print(drawnNode)
            newGraph.add([drawnNode])
        }
        
        print("new", newGraph)
    
        
        let enemyPath = GKPath.init(graphNodes: getEnemyPath(), radius: 1)
        
        print("DO WE?", enemyPath)
        
//        enemypa
        
        let enemyFollowGoal = GKGoal(toStayOn: enemyPath, maxPredictionTime: 1)
        let speedGoal = GKGoal(toReachTargetSpeed: 500)
        
        
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true

        addChild(uiControls)
        addChild(hpDisplay)

        let background = SKSpriteNode(imageNamed: "image/sky")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        addChild(background)
        
//        var playerControlComponent: MovementComponent? {
//            return humanGardener.component(ofType: MovementComponent.self)
//        }
        
        guard let playerControlComponent = humanGardener.component(ofType: MovementComponent.self) else {
            fatalError("Human controlled gardener must have movement animation component")
        }
        
        let playerAgent = playerControlComponent.playerAgent
        self.agentSystem.addComponent(playerAgent!)
        let seekGoal = GKGoal(toSeekAgent: playerControlComponent.playerAgent ?? GKAgent2D())
        
        let wanderGoal = GKGoal(toAvoid: [playerControlComponent.playerAgent ?? GKAgent2D()], maxPredictionTime: 1)
        
        
        var aiControlComponent: EnemyAgentComponent? {
            return aiGardener.component(ofType: EnemyAgentComponent.self)
        }
        
        
        let agent = aiControlComponent?.setUpAgent(with: [enemyFollowGoal, speedGoal, seekGoal])
        self.agentSystem.addComponent(agent!) // DO
                
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
        
        agentSystem.update(deltaTime: deltaTime)

        if let human = entityManager.gardener(for: .team1),
          let humanGardener = human.component(ofType: GardenerComponent.self) {
            hpDisplay.healthText.text = String(humanGardener.health)
            hpDisplay.scoreText.text = String(humanGardener.points)
            
        }
        if let ai = entityManager.gardener(for: .team2),
          let aiGardener = ai.component(ofType: GardenerComponent.self) {
            hpDisplay.healthText.text = String(aiGardener.health)
            hpDisplay.scoreText.text = String(aiGardener.points)
            
        }

        if let component = humanGardener.component(ofType: SpriteComponent.self) {
            if (uiControls.xDist < 0) {
                component.node.position.x -= 0.2 * uiControls.xDist
            } else if (uiControls.xDist > 0) {
                component.node.position.x -= 0.2 * uiControls.xDist
            } else {
//                component.faceForward()
            }
        
        }
       
        
    }
    
    func getEnemyPath() -> [GKGraphNode] {

        return navigationGraph.findPath(from: navigationGraph.nodes![7], to: navigationGraph.nodes![8])
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("LOL")
//        getEnemyPath(to: )
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
