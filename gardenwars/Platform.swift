import SpriteKit

class Platform: SKSpriteNode {
    
    
    init(size: String) {
        let texture = SKTexture(imageNamed: "image/platform1")
       
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        switch size {
            case "large":
                self.scale(to: CGSize(width: ScreenSize.width, height: 50))
            case "medium":
                self.scale(to: CGSize(width: ScreenSize.width / 2, height: 25))
            default:
                self.scale(to: CGSize(width: ScreenSize.width / 2, height: 25))
        }
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: self.size.width,
                                                    height: self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = true
        self.physicsBody?.isDynamic = false
    }
    

    required init?(coder aDecoder: NSCoder) {
      super.init(coder:aDecoder)
    }

}
