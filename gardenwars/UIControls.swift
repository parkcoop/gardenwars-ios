import SpriteKit

class UIControls: SKNode {
    
    var stick = SKSpriteNode(imageNamed: "image/stick")
    var substrate = SKSpriteNode(imageNamed: "image/substrate")
    var stickActive: Bool = false
    var xDist: CGFloat = 0
    var yDist: CGFloat = 0
    var joyStickPoint: CGPoint = CGPoint(x: 0, y: 0)
    var jumpButton = SKSpriteNode(imageNamed: "image/jump")
    
    

    
    func build() {
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

    }
    
    func moveJoystick() {
        let v = CGVector(dx: self.joyStickPoint.x - self.substrate.position.x, dy: self.joyStickPoint.y - self.substrate.position.y)
       let angle = atan2(v.dy, v.dx)
        let length: CGFloat = self.substrate.frame.width / 2

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
