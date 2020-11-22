// 1
import SpriteKit
import GameplayKit

// 2
class SpriteComponent: GKComponent {

  // 3
  let node: SKSpriteNode

  // 4
  init(texture: SKTexture) {
    node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
    super.init()
  }
  
  // 5
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    
    func jump() {
        node.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
    }
}
