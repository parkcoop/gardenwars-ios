import SpriteKit
import GameplayKit

class EnemyGardener: GKEntity, GKAgentDelegate {
    
    
    init(imageName: String, team: Team) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.node.size = CGSize(width: 60, height: 100)
        let xRange = SKRange(lowerLimit: spriteComponent.node.size.width * 0.5, upperLimit: ScreenSize.width - spriteComponent.node.size.width * 0.5)
        let yRange = SKRange(lowerLimit: 0, upperLimit: ScreenSize.height)
        spriteComponent.node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        
        addComponent(spriteComponent)
        let physicsComponent = PhysicsComponent()
        addComponent(physicsComponent)
        
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        
        addComponent(TeamComponent(team: team))
        addComponent(GardenerComponent())
        addComponent(EnemyAgentComponent())
        addComponent(MovementComponent())
//        addComponent(GKAgent2D())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
