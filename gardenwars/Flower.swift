import SpriteKit

class Flower: SKSpriteNode {
    
    private var flowerFrames: SKTextureAtlas = SKTextureAtlas(named: "flower")
    
    var growthPhase = 1

    

    func replenishSoil() -> Bool {
        if (growthPhase >= 6) {
            return false
        }
        growthPhase += 1
        self.texture = flowerFrames.textureNamed("flower\(growthPhase)")
        return true
    }
    
    
    
    
    
    
    
    
    
    convenience init() {
      let texture = SKTexture(imageNamed: "image/soil")
      self.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.growthPhase = 1
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
