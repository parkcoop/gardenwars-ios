import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 100))
        node.physicsBody?.allowsRotation = false
        
        let xRange = SKRange(lowerLimit: node.size.width * 0.5, upperLimit: ScreenSize.width - node.size.width * 0.5)
        let yRange = SKRange(lowerLimit: 0, upperLimit: ScreenSize.height)
        node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func jump() {
        node.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
    }
}
