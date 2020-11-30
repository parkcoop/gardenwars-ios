import SpriteKit
import GameplayKit

class EnemyGardener: GKEntity, GKAgentDelegate {
    
    
    init(imageName: String, team: Team) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        spriteComponent.node.size = CGSize(width: 60, height: 100)
        
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        addComponent(GardenerComponent())
        addComponent(MovementComponent())
        addComponent(EnemyAgentComponent())
        addComponent(GKAgent2D())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum EnemyGardenerMandate {
        // Hunt another agent (either a `PlayerBot` or a "good" `TaskBot`).
//        case huntAgent(GKAgent2D)

        // Follow the `TaskBot`'s "good" patrol path.
        case followGoodPatrolPath

        // Follow the `TaskBot`'s "bad" patrol path.
        case followBadPatrolPath

        // Return to a given position on a patrol path.
        case returnToPositionOnPath(SIMD2<Float>)
    }
    
    
    
    
}
