import SpriteKit

class Level: SKNode {
    var tree = SKSpriteNode(imageNamed: "image/tree1")
    var background = SKSpriteNode(imageNamed: "image/sky")

    var platformLeft = Platform(size: "medium")
    var platformRight = Platform(size: "medium")
    var platformMain = Platform(size: "large")

    let thunder = FallingItem(type: "thunder")
    let sun = FallingItem(type: "sun")
    let water = FallingItem(type: "water")
    
    let soil = Flower(named: "soil")
    let soil2 = Flower(named: "soil2")
    let soil3 = Flower(named: "soil3")
    
    
    override init() {
        super.init()


    }
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
    func replenishSoil(flower: SKNode) -> Bool {
        guard let name = flower.name else {
            return false
        }
        switch name {
        case "soil":
            return soil.replenishSoil()
        case "soil2":
            return soil2.replenishSoil()
        case "soil3":
            return soil3.replenishSoil()
        default:
            return false
        }
    }
    
    
    func buildLevel1() {
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        background.zPosition = -5
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        
        platformLeft.position = CGPoint(x: ScreenSize.width * 0.20, y: ScreenSize.height * 0.35)
        platformRight.position = CGPoint(x: ScreenSize.width * 0.75, y: ScreenSize.height * 0.7)
        platformMain.position = CGPoint(x: ScreenSize.width / 2, y: 0)

        soil.position = CGPoint(x: platformLeft.position.x, y: platformLeft.position.y + 78)
        soil2.position = CGPoint(x: platformMain.position.x + ScreenSize.width / 3, y: platformMain.position.y + 89)
        soil3.position = CGPoint(x: platformRight.position.x, y: platformRight.position.y + 78)

        addNodes()
    }
    
    
    func buildLevel2() {
        replantFlowerBeds()
        background = SKSpriteNode(imageNamed: "image/forest")
        background.zPosition = -5
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        
        platformLeft.texture = SKTexture(imageNamed: "image/platform2")
        platformRight.texture = SKTexture(imageNamed: "image/platform2")
        platformMain.texture = SKTexture(imageNamed: "image/platform2")
        
        platformLeft.position = CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0.7)
        platformRight.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.35)
        platformMain.position = CGPoint(x: ScreenSize.width / 2, y: 0)

        soil.position = CGPoint(x: platformLeft.position.x, y: platformLeft.position.y + 78)
        soil2.position = CGPoint(x: platformMain.position.x + ScreenSize.width / 3, y: platformMain.position.y + 89)
        soil3.position = CGPoint(x: platformRight.position.x, y: platformRight.position.y + 78)

        addNodes()
    }
    
    
    func buildLevel3() {
        replantFlowerBeds()
        background = SKSpriteNode(imageNamed: "image/sunset")
        background.zPosition = -5
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        
        platformLeft.texture = SKTexture(imageNamed: "image/platform3")
        platformRight.texture = SKTexture(imageNamed: "image/platform3")
        platformMain.texture = SKTexture(imageNamed: "image/platform3")
        
        platformLeft.position = CGPoint(x: ScreenSize.width * 0.05, y: ScreenSize.height * 0.3)
        platformRight.position = CGPoint(x: ScreenSize.width * 0.7, y: ScreenSize.height * 0.75)
        platformMain.position = CGPoint(x: ScreenSize.width / 2, y: 0)

        soil.position = CGPoint(x: platformLeft.position.x + 50, y: platformLeft.position.y + 78)
        soil2.position = CGPoint(x: platformMain.position.x + ScreenSize.width / 3, y: platformMain.position.y + 89)
        soil3.position = CGPoint(x: platformRight.position.x, y: platformRight.position.y + 78)

        addNodes()
    }
    
    
    private func addNodes() -> Void {
        addChild(background)
        addChild(platformLeft)
        addChild(platformRight)
        addChild(platformMain)
        addChild(sun)
        addChild(water)
        addChild(thunder)
        addChild(soil)
        addChild(soil2)
        addChild(soil3)
    }
    
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max-min) + min
    }
    
    
    func skyFall(item: SKSpriteNode) -> Void {
        let actualX = random(min: 0, max: ScreenSize.width)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
        duration: TimeInterval(actualDuration))
        item.position = CGPoint(x: actualX, y: ScreenSize.height)
        item.run(actionMove)
    }
    
    func replantFlowerBeds() {
        soil.reset()
        soil2.reset()
        soil3.reset()
    }
    
    
    
}
