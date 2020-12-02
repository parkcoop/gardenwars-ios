import SpriteKit
import GameplayKit

class GardenerComponent: GKComponent {
    
    // 1
    var points = 0
    var health = 100
    var currentItem: String? = nil
    var game: GamePlay?
    
    override init() {
//        game = scene
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if let spriteComponent = entity?.component(ofType: SpriteComponent.self) {

            if let game = game {
                if (spriteComponent.node.calculateAccumulatedFrame().intersects(game.thunder.frame)),
                   game.childNode(withName: "thunder") !== nil {
                    self.takeDamage(points: 10)
                    game.thunder.removeFromParent()
                }
                
                if (spriteComponent.node.frame.intersects(game.sun.frame)),
                   game.childNode(withName: "sun") !== nil {
                    self.grabItem(item: "sun")
                    self.scorePoints(points: 50)
                    game.sun.removeFromParent()
                }
                
                if (spriteComponent.node.frame.intersects(game.water.frame)),
                   game.childNode(withName: "water") !== nil {
                    self.grabItem(item: "water")
                    self.scorePoints(points: 50)
                    game.water.removeFromParent()
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
    
    func takeDamage(points: Int) {
        self.health -= points
    }
    
    func scorePoints(points: Int) {
        self.points += points
    }
}
