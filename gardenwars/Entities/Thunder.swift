import SpriteKit
import GameplayKit


class Thunder: GKEntity, GKAgentDelegate {


    var agent: GKAgent2D
    let spriteComponent: SpriteComponent
    
    override init() {
        agent = GKAgent2D()
        agent.radius = 5
        let texture: SKTexture = SKTexture(imageNamed: "image/thunder")

        spriteComponent = SpriteComponent(texture: texture)

        super.init()
        
        addComponent(spriteComponent)
        addComponent(FallingItemComponent())
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
          if let agent2d = agent as? GKAgent2D {
            agent2d.position = SIMD2<Float>(Float((spriteComponent.node.position.x)), Float((spriteComponent.node.position.y)))
          }
      }
      
      func agentDidUpdate(_ agent: GKAgent) {
          if let agent2d = agent as? GKAgent2D {
            spriteComponent.node.position = CGPoint(x: CGFloat(agent2d.position.x), y: CGFloat(agent2d.position.y))
          }
      }
    /// Sets the `PlayerBot` `GKAgent` position to match the node position (plus an offset).
    func updateAgentPositionToMatchNodePosition() {
        // `renderComponent` is a computed property. Declare a local version so we don't compute it multiple times.
        let renderComponent = self.spriteComponent
        
        
        agent.position = SIMD2<Float>(x: Float(renderComponent.node.position.x ), y: Float(renderComponent.node.position.y))
        
    }
    
    
    func setUpAgent() -> GKAgent2D {
        let position = spriteComponent.node.position
//        agent.maxSpeed = 400
//        agent.maxAcceleration = 600
        agent.radius = 40
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.delegate = self
        return agent
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}
