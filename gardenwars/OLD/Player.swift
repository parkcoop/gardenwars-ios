import SpriteKit

class Player: SKSpriteNode {
    
    private var player1LeftFrames: [SKTexture] = []
    private var player1RightFrames: [SKTexture] = []
    private var player1StillFrame: SKTexture?
    
    private var player1WaterLeftFrames: [SKTexture] = []
    private var player1WaterRightFrames: [SKTexture] = []
    private var player1WaterStillFrames: [SKTexture] = []
    
    private var player1SunLeftFrames: [SKTexture] = []
    private var player1SunRightFrames: [SKTexture] = []
    private var player1SunStillFrames: [SKTexture] = []
    
    public var health = 100
    public var points = 0
    private (set) var currentItem: String = ""
    
    
    init(textureAtlas: String) {
        let player1AnimatedAtlas = SKTextureAtlas(named: textureAtlas)
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []
        for i in 2...4 {
            let player1TextureName = "\(textureAtlas)\(i)"
            leftFrames.append(player1AnimatedAtlas.textureNamed(player1TextureName))
        }
        for i in 6...8 {
            let player1TextureName = "\(textureAtlas)\(i)"
            rightFrames.append(player1AnimatedAtlas.textureNamed(player1TextureName))
        }
        player1StillFrame = player1AnimatedAtlas.textureNamed("\(textureAtlas)5")
        player1LeftFrames = leftFrames
        player1RightFrames = rightFrames
        
        super.init(texture: player1StillFrame!, color: UIColor.clear, size: player1StillFrame!.size())
        self.health = 100
        self.points = 0
        self.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        self.size = CGSize(width: 44, height: 77)
        self.physicsBody = SKPhysicsBody(texture: player1StillFrame!, size: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true;
        
        let xRange = SKRange(lowerLimit: self.size.width * 0.5, upperLimit: ScreenSize.width - self.size.width * 0.5)
        let yRange = SKRange(lowerLimit: 0, upperLimit: ScreenSize.height)
        self.constraints = [SKConstraint.positionX(xRange, y: yRange)]
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
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
        if self.currentItem == "water" {
            self.texture = SKTexture(imageNamed: "image/parker_water")
        } else if self.currentItem == "sun" {
            self.texture = SKTexture(imageNamed: "image/parker_sun")
        } else {
            self.texture = player1StillFrame
        }
    }
    
    
    func takeDamage(points: Int) -> Void {
        self.health -= points
        let pulsedRed = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.15),
            SKAction.wait(forDuration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
        self.run(pulsedRed)
    }
    
    
    func holdItem(item: String) -> Bool {
        if (self.currentItem != "") {
            return false
        }
        self.currentItem = item
        return true
        
    }
    
    
    func garden() -> Void {
        if (self.currentItem == "") {
            return
        }
        self.points += 25
        self.currentItem = ""
    }
    
    
    
}
