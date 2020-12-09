import SpriteKit
import GameplayKit

class GardenerComponent: GKComponent {
    
    var points = 0
    var health = 100
    var currentItem: String? = nil
    var game: GamePlay?
    
    var knockOutSound = SKAction.playSoundFileNamed("knockout.wav", waitForCompletion: false)
    var electrocutionSound = SKAction.playSoundFileNamed("electrocute.mp3", waitForCompletion: false)
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
       
        if let spriteComponent = entity?.component(ofType: SpriteComponent.self) {
           
            if let game = game {
                if (health <= 0) {

    //                spriteComponent.node.isPaused = true
    //                spriteComponent.node.position = CGPoint(x: 50, y: 100)
                    if let physicsBody = entity?.component(ofType: PhysicsComponent.self) {
                        physicsBody.physicsBody.pinned = true
                        spriteComponent.node.run(SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 1))
                    }
                }
                
                if let movementComponent = entity?.component(ofType: MovementComponent.self) {
                    if self.currentItem != nil {
                        movementComponent.holdItemFrames(item: self.currentItem!)
                    } else {
                        movementComponent.resetFrames()
                    }
                    
                }
                if (spriteComponent.node.calculateAccumulatedFrame().intersects(game.thunder.frame)),
                   game.childNode(withName: "thunder") !== nil {
                    if (health == 25) {
                        game.run(knockOutSound)
                    }
                    self.takeDamage(healthPoints: 25)
                    game.thunder.removeFromParent()
                    game.run(electrocutionSound)
                }
                
                if (spriteComponent.node.frame.intersects(game.sun.frame)),
                   game.childNode(withName: "sun") !== nil {
                    self.grabItem(item: "sun")
                    game.sun.removeFromParent()
                    if (entity?.component(ofType: EnemyAgentComponent.self) != nil) {
                        game.enemyStateMachine.enter(HoldingItemState.self)
                    }
                    
                    
                }
                
                if (spriteComponent.node.frame.intersects(game.water.frame)),
                   game.childNode(withName: "water") !== nil {
                    self.grabItem(item: "water")
                    game.water.removeFromParent()
                    if (entity?.component(ofType: EnemyAgentComponent.self) != nil) {
                        game.enemyStateMachine.enter(HoldingItemState.self)
                    }
                }
                
                if (spriteComponent.node.frame.intersects(CGRect(x: game.soil1.frame.midX, y: game.soil1.frame.minY, width: game.soil1.frame.width, height: 10))) {
                    if self.currentItem != nil {
                        if game.soil1.replenishSoil() {
                            self.scorePoints(points: 25)
                            self.currentItem = nil
                            if (entity?.component(ofType: EnemyAgentComponent.self) != nil) {
                                game.enemyStateMachine.enter(NormalState.self)
                            }
                        }
                    }
                }
                
                if (spriteComponent.node.frame.intersects(CGRect(x: game.soil2.frame.midX, y: game.soil2.frame.minY, width: game.soil2.frame.width, height: 10))) {
                    if self.currentItem != nil {
                        if game.soil2.replenishSoil() {
                            self.currentItem = nil
                            self.scorePoints(points: 25)
                            if (entity?.component(ofType: EnemyAgentComponent.self) != nil) {
                                game.enemyStateMachine.enter(NormalState.self)
                            }
                        }
                    }
                }
                
                if (spriteComponent.node.frame.intersects(CGRect(x: game.soil3.frame.midX, y: game.soil3.frame.minY, width: game.soil3.frame.width, height: 10))) {
                    if self.currentItem != nil {
                        if game.soil3.replenishSoil() {
                            self.currentItem = nil
                            self.scorePoints(points: 25)
                        }
                    }
                }
            }
            
        }
        
    }
    
    func initGame(game: GamePlay) {
        self.game = game
    }
    
    func grabItem(item: String) {
        if self.currentItem == nil {
            self.currentItem = item
        }
    }
    
    func takeDamage(healthPoints: Int) {
        if self.health <= 0 {
            return
        }
        self.health -= healthPoints
    }
    
    func scorePoints(points: Int) {
        self.points += points
    }
}
