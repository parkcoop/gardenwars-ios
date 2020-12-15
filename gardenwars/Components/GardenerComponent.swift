import SpriteKit
import GameplayKit

class GardenerComponent: GKComponent {
    
    var points = 0
    var health = 100
    var currentItem: String? = nil
    var game: GamePlay?
    
    var knockOutSound = SKAction.playSoundFileNamed(fileName: "knockout.wav", atVolume: 0.25, waitForCompletion: false)
    var electrocutionSound = SKAction.playSoundFileNamed(fileName: "electrocute.mp3", atVolume: 0.25, waitForCompletion: false)
    
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
                    spriteComponent.node.color = .red

                    if game.firstDeath == nil {
                        if (entity?.component(ofType: EnemyAgentComponent.self) != nil) {
                            game.firstDeath = 2
                        } else {
                            game.firstDeath = 1
                        }
                    }
                    if let enemyAgent = entity?.component(ofType: EnemyAgentComponent.self) {
                        game.agentSystem?.removeComponent(enemyAgent.agent)
                    }
                    if let animation = entity?.component(ofType: MovementComponent.self) {
                        animation.faceForward()
                    }
                    if let physicsBody = entity?.component(ofType: PhysicsComponent.self) {
                        physicsBody.physicsBody.pinned = true
  
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
                    if (health == 20),
                       effectsEnabled {
                        game.run(knockOutSound)
                    }
                    self.takeDamage(healthPoints: 20)
                    game.thunder.removeFromParent()
                    if effectsEnabled { game.run(electrocutionSound) }
                }
                
                if (spriteComponent.node.frame.intersects(game.sun.frame)),
                   game.childNode(withName: "sun") !== nil,
                   self.health != 0 {
                    self.grabItem(item: "sun")
                    game.sun.removeFromParent()
                    game.agentSystem?.removeComponent(game.sunAgent)
                    if (entity?.component(ofType: EnemyAgentComponent.self) != nil) {
                        game.enemyStateMachine.enter(HoldingItemState.self)
                    }
                    
                    
                }
                
                if (spriteComponent.node.frame.intersects(game.water.frame)),
                   game.childNode(withName: "water") !== nil,
                   self.health != 0 {
                    self.grabItem(item: "water")
                    game.water.removeFromParent()
                    game.agentSystem?.removeComponent(game.waterAgent)
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
