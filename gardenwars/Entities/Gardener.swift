import SpriteKit
import GameplayKit

class Gardener: GKEntity {


    init(imageName: String, team: Team) {
        super.init()

        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), size: playerSpriteSize)
//        spriteComponent.node.size = CGSize(width: 60, height: 100)
        let xRange = SKRange(lowerLimit: spriteComponent.node.size.width * 0.5, upperLimit: ScreenSize.width - spriteComponent.node.size.width * 0.5)
        let yRange = SKRange(lowerLimit: 0, upperLimit: ScreenSize.height)
        spriteComponent.node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        addComponent(spriteComponent)
        
        let physicsComponent = PhysicsComponent(texture: SKTexture(imageNamed: imageName), size: playerSpriteSize)
        addComponent(physicsComponent)
        addComponent(TeamComponent(team: team))
        addComponent(GardenerComponent())
        let movementComponent = MovementComponent(texture: chosenCharacter)
        addComponent(movementComponent)
        
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
    }
    
    
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
