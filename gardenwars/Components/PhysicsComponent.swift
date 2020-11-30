import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent {
    
    var physicsBody: SKPhysicsBody
    
    override init() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 100))
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = UInt32(1)
        physicsBody.collisionBitMask = UInt32(1)
        physicsBody.contactTestBitMask = UInt32(1)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
