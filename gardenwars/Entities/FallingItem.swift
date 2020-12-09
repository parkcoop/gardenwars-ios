import SpriteKit
import GameplayKit


class FallingItem: GKEntity {


    init(type: String) {
        super.init()
        var texture: SKTexture
        switch type {
        case "sun":
            texture = SKTexture(imageNamed: "image/sun")
        case "water":
            texture = SKTexture(imageNamed: "image/water")
        default:
            texture = SKTexture(imageNamed: "image/thunder")
        }
        
        let spriteComponent = SpriteComponent(texture: texture, size: texture.size())
        addComponent(spriteComponent)
        let xRange = SKRange(lowerLimit: spriteComponent.node.size.width * 0.5, upperLimit: ScreenSize.width - spriteComponent.node.size.width * 0.5)
        let yRange = SKRange(lowerLimit: 0, upperLimit: ScreenSize.height)
        spriteComponent.node.constraints = [SKConstraint.positionX(xRange, y: yRange)]
//        spriteComponent.node.position = CGPoint(x: 0, y: 5000)

    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}
