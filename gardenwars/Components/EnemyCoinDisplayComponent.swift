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
        coinLabel.fontSize = 10
//        coinIcon.position = CGPoint(x: container.frame.midX - 25, y: container.frame.midY)
        coinLabel.position = CGPoint(x: container.frame.midX, y: container.frame.maxY)
//        coinIcon.scale(to: CGSize(width: 10, height: 22))
        
//        container.addChild(coinIcon)
        container.addChild(coinLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCoinAmount(_ value: String) {
        coinLabel.text = value
    }
    
}
