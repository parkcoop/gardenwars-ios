import SpriteKit

class HealthPoints: SKNode {
    var hpBackground = SKSpriteNode(imageNamed: "image/counter")
    var scoreText = SKLabelNode(fontNamed: "Chalkduster");
    var healthText = SKLabelNode(fontNamed: "Chalkduster")
    
    override init() {
        super.init()
        if (DeviceType.isiPhoneX) {
            hpBackground.position = CGPoint(x: ScreenSize.width * 0.15, y: ScreenSize.height * 0.9)
        } else if (DeviceType.isiPad) {
            hpBackground.position = CGPoint(x: ScreenSize.width * 0.05, y: ScreenSize.height * 0.95)
        } else {
            hpBackground.position = CGPoint(x: ScreenSize.width * 0.2, y: ScreenSize.height * 0.89)
        }
        hpBackground.scale(to: CGSize(width: 250, height: 67))
        hpBackground.zPosition = 0
        addChild(hpBackground)
        scoreText.position = CGPoint(x: hpBackground.position.x - 45, y: hpBackground.position.y - 10)
        scoreText.zPosition = 1
        scoreText.fontSize = CGFloat.universalFont(size: 25)
        healthText.position = CGPoint(x: hpBackground.position.x + 55, y: hpBackground.position.y - 10)
        healthText.zPosition = 1
        healthText.fontSize = CGFloat.universalFont(size: 25)
        addChild(scoreText)
        addChild(healthText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
}
