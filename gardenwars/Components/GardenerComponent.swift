import SpriteKit
import GameplayKit

class GardenerComponent: GKComponent {
    
    // 1
    var points = 0
    var health = 100
    var currentItem: String? = nil
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if let spriteComponent = entity?.component(ofType: SpriteComponent.self) {
        
        
        
        }
//        // Check for intersection
//        if (spriteComponent.node.calculateAccumulatedFrame().intersects(enemySpriteComponent.node.calculateAccumulatedFrame())) {
//
//          // Check damage rate
//          if (CGFloat(CACurrentMediaTime() - lastDamageTime) > damageRate) {
//
//            // Cause damage
//            spriteComponent.node.parent?.run(sound)
//            if (aoe) {
//              aoeDamageCaused = true
//            } else {
//              lastDamageTime = CACurrentMediaTime()
//            }
//
//            // Subtract health
//            enemyHealthComponent.takeDamage(damage)
//
//            // Destroy self
//            if destroySelf {
//              entityManager.remove(entity!)
//            }
//          }
//        }
    }
    
    func grabItem(item: String) {
        self.currentItem = item
    }
}
