import SpriteKit
import GameplayKit

class DeathComponent: GKComponent {

    var coverSprite: SKSpriteNode!
    
    override init() {
        super.init()
        self.coverSprite = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 200))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setProgress(_ value:CGFloat) {
        
    }
    
}
