import SpriteKit

class Gameplay: SKScene {
    
    let platformCategory: UInt32 = 0x1 << 0
     
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode(imageNamed: "image/sky")
    
    var platformLeft = SKSpriteNode(imageNamed: "image/platform1")
    var platformRight = SKSpriteNode(imageNamed: "image/platform1")
    var platformMain = SKSpriteNode(imageNamed: "image/platform1")

    let player = SKSpriteNode(imageNamed: "image/me")
    let arrowLeft = SKSpriteNode(imageNamed: "image/arrowleft")
    let arrowRight = SKSpriteNode(imageNamed: "image/arrowright")
    let arrowUp = SKSpriteNode(imageNamed: "image/arrowup")
    var player1LeftFrames: [SKTexture] = []
    var player1RightFrames: [SKTexture] = []
    var player1StillFrame: SKTexture?
    
    var player1 = SKSpriteNode()

    override func didMove(to view: SKView) {
      
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        for touch in touches {
          let location = touch.location(in: self)
          let touchedNode = self.nodes(at: location)
          for node in touchedNode {
            if node.name == "left" {
                walkLeft()
                player1.position.x -= 25
            }
            if node.name == "right" {
              player1.position.x += 25
                walkRight()
            }
            if node.name == "up" {
                player1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                player1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 55))
            }
          }
      }
    }
    
    
    func buildLevel1() {
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        background.zPosition = -5
        
        platformLeft.position = CGPoint(x: 100, y: ScreenSize.height / 2)
        platformLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformLeft.size.width,
                                                    height: platformLeft.size.height))
        platformLeft.physicsBody?.affectedByGravity = false
        platformLeft.physicsBody?.pinned = true
        platformLeft.physicsBody?.isDynamic = false
        
        platformRight.position = CGPoint(x: 100, y: ScreenSize.height / 2)
        platformRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformRight.size.width,
                                                    height: platformRight.size.height))
        platformRight.physicsBody?.affectedByGravity = false
        platformRight.physicsBody?.pinned = true
        platformRight.physicsBody?.isDynamic = false
        
        platformMain.position = CGPoint(x: ScreenSize.width / 2, y: 0)
        platformMain.scale(to: CGSize(width: ScreenSize.width, height: 25))
        platformMain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformMain.size.width,
                                                    height: platformMain.size.height))
        platformMain.physicsBody?.affectedByGravity = false
        platformMain.physicsBody?.pinned = true
        platformMain.physicsBody?.isDynamic = false

        arrowLeft.name = "left"
        arrowLeft.position = CGPoint(x: ((ScreenSize.width / 3) - 60), y: ScreenSize.height / 3)
        arrowLeft.size = CGSize(width: 50, height: 20)
        arrowLeft.zPosition = 10
        
        arrowRight.name = "right"
        arrowRight.position = CGPoint(x: ((ScreenSize.width / 3)), y: ScreenSize.height / 3)
        arrowRight.size = CGSize(width: 50, height: 20)
        arrowRight.zPosition = 10

        arrowUp.name = "up"
        arrowUp.position = CGPoint(x: (ScreenSize.width - (ScreenSize.width / 3)), y: ScreenSize.height / 3)
        arrowUp.size = CGSize(width: 50, height: 20)
        arrowUp.zPosition = 10
        addChild(background)
        addChild(platformLeft)
        addChild(platformRight)
        addChild(platformMain)

        addChild(arrowLeft)
        addChild(arrowRight)
        addChild(arrowUp)
    }
    
    
    func buildPlayer1() {
        let player1AnimatedAtlas = SKTextureAtlas(named: "parker")
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []

        print(player1AnimatedAtlas)
        
        for i in 1...4 {
            let player1TextureName = "parker\(i)"
            leftFrames.append(player1AnimatedAtlas.textureNamed(player1TextureName))
        }
        
        for i in 6...9 {
            let player1TextureName = "parker\(i)"
            print(player1TextureName)
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
        player1.size = CGSize(width: 32, height: 48)
        player1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player1.size.width, height: player1.size.height))
        player1.physicsBody?.allowsRotation = false
        player1.physicsBody?.isDynamic = true;
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        faceForward()
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    
    func walkLeft() {
        player1.run(SKAction.repeat(
            SKAction.animate(
                 with: player1LeftFrames,
                 timePerFrame: 0.1,
                 resize: false,
                 restore: true
            ), count: 1
            ))
    }
    
    
    func walkRight() {
        player1.run(SKAction.repeat(
            SKAction.animate(
                 with: player1RightFrames,
                 timePerFrame: 0.1,
                 resize: false,
                 restore: true
            ), count: 1
            ))
    }
    
    
    func faceForward() {
        player1.texture = player1StillFrame
    }
    
    
    // Abstract?
    func addThunder() {
        let thunder = SKSpriteNode(imageNamed: "image/thunder")
        thunder.size = CGSize(width: 50, height: 50)
        let actualX = random(min: ScreenSize.width / 2, max: ScreenSize.width / 2)
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
        let actualX = random(min: ScreenSize.width / 2, max: ScreenSize.width / 2)
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
        let actualX = random(min: ScreenSize.width / 2, max: ScreenSize.width / 2)
        water.position = CGPoint(x: actualX, y: size.width + water.size.width/2)
        addChild(water)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        water.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
