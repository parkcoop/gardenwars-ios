import SpriteKit

class UIControls: SKNode {
    
    var stick = SKSpriteNode(imageNamed: "image/stick")
    var substrate = SKSpriteNode(imageNamed: "image/substrate")
    var stickActive: Bool = false
    var xDist: CGFloat = 0
    var yDist: CGFloat = 0
    var joyStickPoint: CGPoint = CGPoint(x: 0, y: 0)
    var jumpButton = SKSpriteNode(imageNamed: "image/jump")
    
    
    var leftSideOfScreen = SKSpriteNode(color: .clear, size: CGSize(width: ScreenSize.width / 2, height: ScreenSize.height * 0.8))
    var rightSideOfScreen = SKSpriteNode(color: .clear, size: CGSize(width: ScreenSize.width / 2, height: ScreenSize.height * 0.8))

    
    override init() {
        super.init()
        addChild(stick)
        addChild(substrate)
        stick.position = CGPoint(x: 100, y: 100)
        substrate.position = stick.position
        stick.scale(to: CGSize(width: 150, height: 150))
        
        leftSideOfScreen.name = "leftSide"
        rightSideOfScreen.name = "rightSide"
        
        leftSideOfScreen.position = CGPoint(x: ScreenSize.width / 4, y: (ScreenSize.height / 2 - ScreenSize.height * 0.2))
        rightSideOfScreen.position = CGPoint(x: ScreenSize.width * 0.75, y: ScreenSize.height / 2 - ScreenSize.height * 0.2)

        addChild(leftSideOfScreen)
        addChild(rightSideOfScreen)
        let substrateXRange = SKRange(lowerLimit: substrate.frame.width * 0.5, upperLimit: (ScreenSize.width / 2) - substrate.frame.width * 0.5)
        let substrateYRange = SKRange(lowerLimit: substrate.frame.width * 0.5, upperLimit: ScreenSize.height - substrate.frame.width * 0.5)
        let jumpButtonXRange = SKRange(lowerLimit: (ScreenSize.width / 2) + jumpButton.frame.width * 0.5, upperLimit: ScreenSize.width - jumpButton.frame.width * 0.5)
        let jumpButtonYRange = SKRange(lowerLimit: jumpButton.frame.width * 0.5, upperLimit: (ScreenSize.height) - jumpButton.frame.width * 0.5)
        
        substrate.constraints = [SKConstraint.positionX(substrateXRange, y: substrateYRange)]
        jumpButton.constraints = [SKConstraint.positionX(jumpButtonXRange, y: jumpButtonYRange)]
//        addComponent(spriteComponent)
        
        
        
        substrate.scale(to: stick.size)
        
        addChild(jumpButton)
        stick.zPosition = 5000
        substrate.zPosition = 5000
        jumpButton.zPosition = 5000
        jumpButton.name = "jump"
        jumpButton.position = CGPoint(x: ((ScreenSize.width * 0.85)), y: ScreenSize.height * 0.25 )
        jumpButton.scale(to: CGSize(width: 75, height: 75))
        
//        jumpButton.constraints = [SKConstraint.pos]
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
    func moveJoystick() {
        let v = CGVector(dx: self.joyStickPoint.x - self.substrate.position.x, dy: self.joyStickPoint.y - self.substrate.position.y)
        let angle = atan2(v.dy, v.dx)
        let length: CGFloat = self.substrate.frame.width / 5
        
        self.xDist = sin(angle - 1.57079633) * length
        self.yDist = cos(angle - 1.57079633) * length
        
        self.stick.position = CGPoint(x: self.substrate.position.x - self.xDist, y: self.substrate.position.y + self.yDist)
        
        if (self.substrate.frame.contains(self.joyStickPoint)) {
            self.stick.position = self.joyStickPoint
        } else {
            self.stick.position = CGPoint(x: self.substrate.position.x - self.xDist, y: self.substrate.position.y + self.yDist)
        }
    }
}
