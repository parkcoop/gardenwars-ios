import SpriteKit

class Flower: SKSpriteNode {
    
    private var flowerFrames: SKTextureAtlas = SKTextureAtlas(named: "flower")
    
    var growthPhase = 0

    
    func replenishSoil(item: String) -> Void {
        growthPhase += 1
        self.texture = flowerFrames.textureNamed("flower\(growthPhase)")
    }
    
    
    
    
    
    
    
    
    
    convenience init() {
      let texture = SKSpriteNode(imageNamed: "image/soil")
      self.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.growthPhase = 0
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder:aDecoder)
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
      super.init(texture: texture, color: color, size: size)
    }
    
    
    
    
    
    
    
    
    func build() -> Void {


    }
    
    
}
