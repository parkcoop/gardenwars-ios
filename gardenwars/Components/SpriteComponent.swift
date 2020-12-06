import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture, size: CGSize) {
        print(texture.size(), texture)
        node = SKSpriteNode(texture: texture, color: .white, size: size)
//        node.size = node.scale(to: CGSize(width: 50, height: 50))
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
