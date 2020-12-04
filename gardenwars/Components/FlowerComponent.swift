import SpriteKit
import GameplayKit

class FlowerComponent: GKComponent {
    
    private var flowerFrames: SKTextureAtlas = SKTextureAtlas(named: "flower")
    var growthPhase = 1
    
    
    override init() {
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func replenishSoil() -> Bool {
        if (growthPhase >= 6) {
            return false
        }
        growthPhase += 1
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            fatalError()
        }
        spriteComponent.node.texture = flowerFrames.textureNamed("flower\(growthPhase)")
        return true
    }
    
    
    func reset() {
        growthPhase = 1
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            fatalError()
        }
        spriteComponent.node.texture = flowerFrames.textureNamed("flower\(growthPhase)")
        
    }
    
    
}
