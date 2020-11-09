import SpriteKit

class Gameplay: SKScene {
    private var activeTouches = [UITouch:String]()

    let platformCategory: UInt32 = 0x1 << 0
     
    private var label : SKLabelNode?
    
    var stick = SKSpriteNode(imageNamed: "image/stick")
    var substrate = SKSpriteNode(imageNamed: "image/substrate")
    var stickActive: Bool = false
    var xDist: CGFloat = 0
    var joyStickPoint: CGPoint = CGPoint(x: 0, y: 0)
    var jumpButton = SKSpriteNode(imageNamed: "image/jump")
    
    var background = SKSpriteNode(imageNamed: "image/sky")
    var platformLeft = SKSpriteNode(imageNamed: "image/platform1")
    var platformRight = SKSpriteNode(imageNamed: "image/platform1")
    var platformMain = SKSpriteNode(imageNamed: "image/platform1")
    let arrowLeft = SKSpriteNode(imageNamed: "image/arrowleft")
    let arrowRight = SKSpriteNode(imageNamed: "image/arrowright")
    let arrowUp = SKSpriteNode(imageNamed: "image/arrowup")
    
    var player1LeftFrames: [SKTexture] = []
    var player1RightFrames: [SKTexture] = []
    var player1StillFrame: SKTexture?
    
    var player1 = SKSpriteNode()

    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = true
        buildLevel1()
        buildPlayer1()

        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(addThunder),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(addSun),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(addWater),
                SKAction.wait(forDuration: 1.0),
            ])
        ))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (xDist < 0) {
            player1.position.x -= 0.1 * xDist
        } else if (xDist > 0) {
            player1.position.x -= 0.1 * xDist
        } else {
            faceForward()
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
            if (substrate.frame.contains(location)) {
                activeTouches[touch] = "joystick"
                tapBegin(on: "joystick")
                stickActive = true
            } else {
                stickActive = false
            }
            
           
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            let touchedNode = self.nodes(at: location)
          
            if (substrate.frame.contains(location)) {
                joyStickPoint = location
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
           let v = CGVector(dx: joyStickPoint.x - substrate.position.x, dy: joyStickPoint.y - substrate.position.y)
           let angle = atan2(v.dy, v.dx)
           let length: CGFloat = substrate.frame.width / 2

           xDist = sin(angle - 1.57079633) * length
           let yDist: CGFloat = cos(angle - 1.57079633) * length

           stick.position = CGPoint(x: substrate.position.x - xDist, y: substrate.position.y + yDist)

           if (substrate.frame.contains(joyStickPoint)) {
               stick.position = joyStickPoint
           } else {
               stick.position = CGPoint(x: substrate.position.x - xDist, y: substrate.position.y + yDist)
           }
            print("IS IT PLAYING?", player1.hasActions())
            print(player1.physicsBody?.velocity)
            if (xDist < 0) {
//                if (!player1.hasActions()) {
                    walkRight()
//                }
            } else if (xDist > 0) {
//                if (!player1.hasActions()) {
                    walkLeft()
//                }
            } else {
                faceForward()
            }
       }

    }

       private func tapEnd(on button:String) {
        if (button == "joystick") {
            xDist = 0
            stickActive = false
            let move:SKAction = SKAction.move(to: substrate.position, duration: 0.2)
                move.timingMode = .easeOut
                stick.run(move)
        }
       }
    
    
    func buildLevel1() {
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        background.zPosition = -5
        
        platformLeft.position = CGPoint(x: ScreenSize.width * 0.20, y: ScreenSize.height * 0.35)
        platformLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformLeft.size.width,
                                                    height: platformLeft.size.height))
        platformLeft.scale(to: CGSize(width: ScreenSize.width / 2, height: 25))
        platformLeft.physicsBody?.affectedByGravity = false
        platformLeft.physicsBody?.pinned = true
        platformLeft.physicsBody?.isDynamic = false
        
        platformRight.position = CGPoint(x: ScreenSize.width * 0.75, y: ScreenSize.height * 0.7)
        platformRight.scale(to: CGSize(width: ScreenSize.width / 2, height: 25))
        platformRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformRight.size.width,
                                                    height: platformRight.size.height))
        platformRight.physicsBody?.affectedByGravity = false
        platformRight.physicsBody?.pinned = true
        platformRight.physicsBody?.isDynamic = false
        
        platformMain.position = CGPoint(x: ScreenSize.width / 2, y: 0)
        platformMain.scale(to: CGSize(width: ScreenSize.width, height: 50))
        platformMain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformMain.size.width,
                                                    height: platformMain.size.height))
        platformMain.physicsBody?.affectedByGravity = false
        platformMain.physicsBody?.pinned = true
        platformMain.physicsBody?.isDynamic = false
        
        addChild(stick)
        addChild(substrate)
        stick.position = CGPoint(x: 100, y: 100)
        substrate.position = stick.position
        stick.scale(to: CGSize(width: 150, height: 150))
        
        substrate.scale(to: stick.size)
        
        addChild(jumpButton)
        jumpButton.name = "jump"
        jumpButton.position = CGPoint(x: ((ScreenSize.width * 0.85)), y: ScreenSize.height * 0.25 )
        jumpButton.scale(to: CGSize(width: 75, height: 75))


        addChild(background)
        addChild(platformLeft)
        addChild(platformRight)
        addChild(platformMain)

//        addChild(arrowLeft)
//        addChild(arrowRight)
//        addChild(arrowUp)
    }
    
    
    func buildPlayer1() {
        let player1AnimatedAtlas = SKTextureAtlas(named: "parker")
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []
        
        for i in 2...4 {
            let player1TextureName = "parker\(i)"
            leftFrames.append(player1AnimatedAtlas.textureNamed(player1TextureName))
        }
        
        for i in 6...8 {
            let player1TextureName = "parker\(i)"
            rightFrames.append(player1AnimatedAtlas.textureNamed(player1TextureName))
        }
        player1StillFrame = player1AnimatedAtlas.textureNamed("parker5")
        player1LeftFrames = leftFrames
        player1RightFrames = rightFrames
        
        let firstFrameTexture = player1StillFrame
        player1 = SKSpriteNode(texture: firstFrameTexture)
        player1.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(player1)
        player1.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        player1.size = CGSize(width: 44, height: 77)
        player1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "image/parker"), size: player1.size)
        player1.physicsBody?.allowsRotation = false
        player1.physicsBody?.isDynamic = true;
//        player1.constraints = SKConstraint.positionX(xRange: SKRange(lowerLimit: 0, upperLimit: ScreenSize.width), y: SKRange(lowerLimit: 0, upperLimit: ScreenSize.height))
    }
    
    

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    func actionForKeyIsRunning(key: String) -> Bool {
        return self.action(forKey: key) != nil ? true : false
    }
    
    func walkLeft() {
        if (player1.action(forKey: "WALK_LEFT") != nil) {
            return
        }
        player1.run(SKAction.repeat(
            SKAction.animate(
                 with: player1LeftFrames,
                 timePerFrame: 0.05,
                 resize: false,
                 restore: false
            ), count: 2
        ), withKey: "WALK_LEFT")
    }
    
    
    func walkRight() {
        if (player1.action(forKey: "WALK_RIGHT") != nil) {
            return
        }
        player1.run(SKAction.repeat(
            SKAction.animate(
                 with: player1RightFrames,
                 timePerFrame: 0.05,
                 resize: false,
                 restore: false
            ), count: 2
            ), withKey: "WALK_RIGHT")
    }
    
    
    func faceForward() {
        player1.texture = player1StillFrame
    }
    
    
    // Abstract?
 

    func addThunder() {
        let thunder = SKSpriteNode(imageNamed: "image/thunder")
        thunder.size = CGSize(width: 50, height: 50)
        let actualX = random(min: 0, max: ScreenSize.width)
        thunder.position = CGPoint(x: actualX, y: size.width + thunder.size.width/2)
        addChild(thunder)
        
        // Speed
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        // Move
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
        duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        thunder.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    func addSun() {
        let sun = SKSpriteNode(imageNamed: "image/sun")
        sun.size = CGSize(width: 50, height: 50)
        let actualX = random(min: 0, max: ScreenSize.width)
        sun.position = CGPoint(x: actualX, y: size.width + sun.size.width/2)
        addChild(sun)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        sun.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    func addWater() {
        let water = SKSpriteNode(imageNamed: "image/water")
        water.size = CGSize(width: 50, height: 50)
        let actualX = random(min: 0, max: ScreenSize.width)
        water.position = CGPoint(x: actualX, y: size.width + water.size.width/2)
        addChild(water)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        water.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
