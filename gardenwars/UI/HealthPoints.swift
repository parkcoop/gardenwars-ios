import SpriteKit

class HealthPoints: SKNode {
    var hpBackground = SKSpriteNode(imageNamed: "image/counter")
    var scoreText = SKLabelNode(fontNamed: systemFont);
    var healthText = SKLabelNode(fontNamed: systemFont)
    
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
        scoreText.position = CGPoint(x: hpBackground.frame.minX + hpBackground.frame.width / 4 + 17.5, y: hpBackground.frame.maxY - 45)
        scoreText.horizontalAlignmentMode = .center
        healthText.horizontalAlignmentMode = .center
        scoreText.zPosition = 1
        scoreText.fontSize = CGFloat.universalFont(size: 18)
        healthText.position = CGPoint(x: hpBackground.frame.maxX - hpBackground.frame.width / 4, y: hpBackground.frame.maxY - 45)
        healthText.zPosition = 1
        healthText.fontSize = CGFloat.universalFont(size: 18)
        addChild(scoreText)
        addChild(healthText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
}
