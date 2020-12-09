import SpriteKit
import GameplayKit

class HPSpriteBar: GKComponent {
    var container = SKNode()
    var baseSprite: SKSpriteNode!
    var coverSprite: SKSpriteNode!
    
    override init() {
        super.init()
        self.baseSprite = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 10))
        self.coverSprite = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 10))
                
        container.addChild(baseSprite)
        container.addChild(coverSprite)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setProgress(_ value:CGFloat) {
        guard 0.0 ... 1.0 ~= value else { return }
        let originalSize = self.baseSprite.size
        var calculateFraction:CGFloat = 0.0
        self.coverSprite.position = self.baseSprite.position
        if value == 0.0 {
            calculateFraction = originalSize.width
        } else if 0.01..<1.0 ~= value {
            calculateFraction = originalSize.width - (originalSize.width * value)
        }
        self.coverSprite.size = CGSize(width: originalSize.width-calculateFraction, height: originalSize.height)
        if value>0.0 && value<1.0 {
            self.coverSprite.position = CGPoint(x:(self.coverSprite.position.x-calculateFraction)/2,y:self.coverSprite.position.y)
        }
    }
    
}
