import SpriteKit
import GameplayKit

class Gardener: GKEntity {

    init(imageName: String, team: Team) {
        super.init()

        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.node.size = CGSize(width: 60, height: 100)

        
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        addComponent(GardenerComponent())
//        addComponent(PhysicsComponent(physicsBody: SKPhysicsBody(rectangleOf: spriteComponent.node.size)))
        addComponent(MovementComponent())
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
