import SpriteKit

class Flower: SKSpriteNode {
    
    private var flowerFrames: SKTextureAtlas = SKTextureAtlas(named: "flower")
    var growthPhase = 1
    var growthSound = SKAction.playSoundFileNamed("flowergrowth.wav", waitForCompletion: false)
    var bloomSound = SKAction.playSoundFileNamed("flowercomplete.wav", waitForCompletion: false)

    init(named name: String) {
        let texture = SKTexture(imageNamed: "image/soil")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = name
        self.growthPhase = 1
//        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
//        self.physicsBody?.allowsRotation = false
//        self.physicsBody?.pinned = true
//        self.physicsBody?.isDynamic = false
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
        if (growthPhase == 6) {
            self.run(bloomSound)
        } else {
            self.run(growthSound)
        }
        return true
    }
    
    
    func reset() {
        growthPhase = 1
        self.texture = flowerFrames.textureNamed("flower\(growthPhase)")
        
    }
    
    
}
