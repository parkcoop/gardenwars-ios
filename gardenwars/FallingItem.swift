import SpriteKit

class FallingItem: SKSpriteNode {
    
    
    init(type: String) {
        var texture: SKTexture
        switch type {
        case "sun":
            texture = SKTexture(imageNamed: "image/sun")
        case "water":
            texture = SKTexture(imageNamed: "image/water")
        case "thunder":
            texture = SKTexture(imageNamed: "image/thunder")
        default:
            texture = SKTexture(imageNamed: "image/thunder")
        }
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = type
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.isDynamic = false;
        self.size = CGSize(width: 50, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
