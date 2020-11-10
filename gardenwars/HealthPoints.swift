import SpriteKit

class HealthPoints: SKNode {
    var hpBackground = SKSpriteNode(imageNamed: "image/counter")
    var scoreText = SKLabelNode(fontNamed: "Chalkduster");
    var healthText = SKLabelNode(fontNamed: "Chalkduster")

    func build() {
        hpBackground.position = CGPoint(x: ScreenSize.width * 0.15, y: ScreenSize.height * 0.9)
        hpBackground.scale(to: CGSize(width: 250, height: 67))
        addChild(hpBackground)
        scoreText.position = CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0.875)
        scoreText.zPosition = 50
        healthText.position = CGPoint(x: ScreenSize.width * 0.2, y: ScreenSize.height * 0.875)
        healthText.zPosition = 50
        addChild(scoreText)
        addChild(healthText)


    }

}
