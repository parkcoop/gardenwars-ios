import SpriteKit

class Player: SKSpriteNode {
    
    private var player1LeftFrames: [SKTexture] = []
    private var player1RightFrames: [SKTexture] = []
    private var player1StillFrame: SKTexture?
    public var health = 100
    public var points = 0
    public var currentItem: String = ""
    
    func takeDamage(points: Int) -> Void {
        self.health -= points
    }
    
    func holdItem(item: String) -> Void {
        if (self.currentItem != "") {
            return
        }
        self.currentItem = item
    }
    
    func replenishSoil() {
        if (self.currentItem == "") {
            return
        }
        self.points += 25
        self.currentItem = ""
    }
    
    
    
    
    
    
    
    
    
    convenience init() {
      let texture = SKTexture(imageNamed: "image/me")
      self.init(texture: texture, color: UIColor.clear, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder:aDecoder)
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
      super.init(texture: texture, color: color, size: size)
    }
    
    
    
    
    
    
    
    
    func buildPlayer1() -> Void {
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
        
        let firstFrameTexture = player1StillFrame!
        self.position = CGPoint(x: frame.midX, y: frame.midY)
        self.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        self.size = CGSize(width: 44, height: 77)
        self.physicsBody = SKPhysicsBody(texture: firstFrameTexture, size: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true;
//        player1.constraints = SKConstraint.positionX(xRange: SKRange(lowerLimit: 0, upperLimit: ScreenSize.width), y: SKRange(lowerLimit: 0, upperLimit: ScreenSize.height))
    }
    
    func walkLeft() -> Void {
        if (self.action(forKey: "WALK_LEFT") != nil) {
            return
        }
        self.run(SKAction.repeat(
            SKAction.animate(
                 with: player1LeftFrames,
                 timePerFrame: 0.05,
                 resize: false,
                 restore: false
            ), count: 2
        ), withKey: "WALK_LEFT")
    }
    
    
    func walkRight() -> Void {
        if (self.action(forKey: "WALK_RIGHT") != nil) {
            return
        }
        self.run(SKAction.repeat(
            SKAction.animate(
                 with: player1RightFrames,
                 timePerFrame: 0.05,
                 resize: false,
                 restore: false
            ), count: 2
            ), withKey: "WALK_RIGHT")
    }
    
    
    func faceForward() -> Void {
        self.texture = player1StillFrame
    }
    
    
    
}
