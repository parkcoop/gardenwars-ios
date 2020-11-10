import SpriteKit

class Level: SKNode {
    var tree = SKSpriteNode(imageNamed: "image/tree1")
    var background = SKSpriteNode(imageNamed: "image/sky")
    var platformLeft = SKSpriteNode(imageNamed: "image/platform1")
    var platformRight = SKSpriteNode(imageNamed: "image/platform1")
    var platformMain = SKSpriteNode(imageNamed: "image/platform1")
    let arrowLeft = SKSpriteNode(imageNamed: "image/arrowleft")
    let arrowRight = SKSpriteNode(imageNamed: "image/arrowright")
    let arrowUp = SKSpriteNode(imageNamed: "image/arrowup")
    let thunder = SKSpriteNode(imageNamed: "image/thunder")
    let sun = SKSpriteNode(imageNamed: "image/sun")
    let water = SKSpriteNode(imageNamed: "image/water")
    
    func buildLevel1() {
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        background.zPosition = -5
        
        platformLeft.position = CGPoint(x: ScreenSize.width * 0.20, y: ScreenSize.height * 0.35)
        platformLeft.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformLeft.size.width,
                                                    height: platformLeft.size.height))
        platformLeft.scale(to: CGSize(width: ScreenSize.width / 2, height: 25))
        platformLeft.physicsBody?.affectedByGravity = false
        platformLeft.physicsBody?.pinned = true
        platformLeft.physicsBody?.isDynamic = false
        
        platformRight.position = CGPoint(x: ScreenSize.width * 0.75, y: ScreenSize.height * 0.7)
        platformRight.scale(to: CGSize(width: ScreenSize.width / 2, height: 25))
        platformRight.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformRight.size.width,
                                                    height: platformRight.size.height))
        platformRight.physicsBody?.affectedByGravity = false
        platformRight.physicsBody?.pinned = true
        platformRight.physicsBody?.isDynamic = false
        
        platformMain.position = CGPoint(x: ScreenSize.width / 2, y: 0)
        platformMain.scale(to: CGSize(width: ScreenSize.width, height: 50))
        platformMain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                                                    width: platformMain.size.width,
                                                    height: platformMain.size.height))
        platformMain.physicsBody?.affectedByGravity = false
        platformMain.physicsBody?.pinned = true
        platformMain.physicsBody?.isDynamic = false
        
        addChild(background)
        addChild(platformLeft)
        addChild(platformRight)
        addChild(platformMain)
        addChild(sun)
        addChild(water)
        addChild(thunder)

    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    func addThunder() -> Void {
//        let thunder = SKSpriteNode(imageNamed: "image/thunder")
        thunder.size = CGSize(width: 50, height: 50)
        let actualX = random(min: 0, max: ScreenSize.width)
        thunder.position = CGPoint(x: actualX, y: ScreenSize.height)
        
        // Speed
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

        // Move
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
        duration: TimeInterval(actualDuration))
        thunder.run(actionMove)
    }
    func addSun() -> Void {
        sun.size = CGSize(width: 50, height: 50)
        let actualX = random(min: 0, max: ScreenSize.width)
        sun.position = CGPoint(x: actualX, y: 555 + sun.size.width/2)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
                                       duration: TimeInterval(actualDuration))
        sun.run(actionMove)
    }
    func addWater() -> Void {
        water.size = CGSize(width: 50, height: 50)
        let actualX = random(min: 0, max: ScreenSize.width)
        water.position = CGPoint(x: actualX, y: 555 + water.size.width/2)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -200),
                                       duration: TimeInterval(actualDuration))
        water.run(actionMove)
    }
}
