import SpriteKit
import GameplayKit

class EnemyCoinDisplayComponent: GKComponent {
    var container = SKNode()
    var coinIcon: SKSpriteNode!
    var coinLabel = SKLabelNode(fontNamed: systemFont)
    
    override init() {
        super.init()
        let coinIcon = SKSpriteNode(imageNamed: "image/coin")
        coinLabel.text = String(0)
        coinIcon.scale(to: CGSize(width: 15, height: 30))

        container.addChild(coinIcon)
        container.addChild(coinLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCoinAmount(_ value: String) {
        coinLabel.text = value
    }
    
}
