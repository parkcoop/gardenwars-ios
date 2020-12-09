import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent {
    
    var physicsBody: SKPhysicsBody
    
    
    init(texture: SKTexture, size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = UInt32(1)
        physicsBody.collisionBitMask = UInt32(2)
        physicsBody.contactTestBitMask = UInt32(3)
        super.init()
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
