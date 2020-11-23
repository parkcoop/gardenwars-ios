import SpriteKit
import GameplayKit


class Thunder: GKEntity {


    override init() {
        super.init()
        let texture: SKTexture = SKTexture(imageNamed: "image/thunder")
        
        let spriteComponent = SpriteComponent(texture: texture)
        addComponent(spriteComponent)

    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}
