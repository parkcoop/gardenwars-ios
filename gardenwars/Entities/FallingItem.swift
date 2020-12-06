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
//        spriteComponent.node.position = CGPoint(x: 0, y: 5000)

    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}
