import SpriteKit
import GameplayKit

// 1
class AiComponent: GKAgent2D, GKAgentDelegate {

  // 2
  let entityManager: EntityManager

  // 3
  init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
    self.entityManager = entityManager
    super.init()
    delegate = self
    self.maxSpeed = maxSpeed
    self.maxAcceleration = maxAcceleration
    self.radius = radius
    print(self.mass)
    self.mass = 0.01
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    override func update(deltaTime seconds: TimeInterval) {

    }

  // 4
  func agentWillUpdate(_ agent: GKAgent) {
    guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
      return
    }
    spriteComponent.node.position = CGPoint(x: 50, y: 50)

//    spriteComponent.node.position = CGPoint(from: spriteComponent.node.position) as! Decoder
  }

  // 5
  func agentDidUpdate(_ agent: GKAgent) {
    guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
      return
    }
    spriteComponent.node.position = CGPoint(x: 50, y: 50)

//    spriteComponent.node.position = CGPoint(from: spriteComponent.node.position)
  }
}
