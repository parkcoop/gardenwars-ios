import SpriteKit
import GameplayKit

class EnemyGardener: GKEntity, GKAgentDelegate {
    
    let hpBarComponent = HPSpriteBar()
    let coinDisplayComponent = EnemyCoinDisplayComponent()
    
    init(imageName: String, team: Team) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), size: playerSpriteSize)
        let xRange = SKRange(lowerLimit: spriteComponent.node.size.width * 0.5, upperLimit: ScreenSize.width - spriteComponent.node.size.width * 0.5)
        let yRange = SKRange(lowerLimit: spriteComponent.node.size.height * 0.75, upperLimit: ScreenSize.height * 0.7)
        spriteComponent.node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
        
        addComponent(spriteComponent)
        let physicsComponent = PhysicsComponent(texture: SKTexture(imageNamed: imageName), size: playerSpriteSize)
        addComponent(physicsComponent)
        
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        
        addComponent(TeamComponent(team: team))
        addComponent(GardenerComponent())
        addComponent(EnemyAgentComponent())
        let movementComponent = MovementComponent(texture: enemyCharacter)
        addComponent(movementComponent)
        
        
        addComponent(hpBarComponent)
        addComponent(coinDisplayComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let gardenComponent = self.component(ofType: GardenerComponent.self) else {
            fatalError("No garden component on AI gardener")
        }
        hpBarComponent.setProgress(CGFloat(Double(gardenComponent.health) / 100.00))
        coinDisplayComponent.setCoinAmount(String(gardenComponent.points))
        
    }
    
    
    
}
