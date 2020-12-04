import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: CGSize(width: 50, height: 100))
        node.zPosition = 5
//        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 100))
//        node.physicsBody?.allowsRotation = false
        

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func jump() {
        node.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
    }
}
