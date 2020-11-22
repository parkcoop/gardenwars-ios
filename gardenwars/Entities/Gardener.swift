import SpriteKit
import GameplayKit

class Gardener: GKEntity {

    init(imageName: String, team: Team) {
        super.init()

        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.node.size = CGSize(width: 60, height: 100)
        
//        let physicsComponent = PhysicsComponent(body: SKPhysicsBody(rectangleOf: spriteComponent.node.size))
//        physicsComponent.physicsBody.usesPreciseCollisionDetection = true
//        physicsComponent.physicsBody.affectedByGravity = true
        
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        addComponent(GardenerComponent())
        addComponent(GKSKNodeComponent(node: spriteComponent.node))
        addComponent(PhysicsComponent(body: SKPhysicsBody(rectangleOf: spriteComponent.node.size)))
        addComponent(MovementComponent())
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
