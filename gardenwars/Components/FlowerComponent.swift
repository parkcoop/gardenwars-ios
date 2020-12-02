import SpriteKit
import GameplayKit

class FlowerComponent: GKComponent {
    
    private var flowerFrames: SKTextureAtlas = SKTextureAtlas(named: "flower")
    var growthPhase = 1
    
    
    override init() {
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
    func replenishSoil() -> Bool {
        if (growthPhase >= 6) {
            return false
        }
        growthPhase += 1
        self.texture = flowerFrames.textureNamed("flower\(growthPhase)")
        return true
    }
    
    
    func reset() {
        growthPhase = 1
        self.texture = flowerFrames.textureNamed("flower\(growthPhase)")
        
    }
    
    
}
