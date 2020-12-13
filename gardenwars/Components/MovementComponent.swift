//
//  MovementComponent.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/22/20.
//
import SpriteKit
import GameplayKit

class MovementComponent: GKComponent, GKAgentDelegate {
    private var spriteLeftFrames: [SKTexture] = []
    private var spriteRightFrames: [SKTexture] = []
    private var spriteStillFrame: SKTexture?
    
    var playerAgent: GKAgent2D? = GKAgent2D()
    var playerTexture: String

    private var node: SKSpriteNode {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else {
            fatalError("This entity don't have node")
        }
        return node
    }

    init(texture: String) {
        self.playerTexture = texture
        super.init()
        let spriteAnimatedAtlas = SKTextureAtlas(named: playerTexture)
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []
        for i in 2...4 {
            let spriteTextureName = "\(playerTexture)\(i)"
            leftFrames.append(spriteAnimatedAtlas.textureNamed(spriteTextureName))
        }
        for i in 6...8 {
            let spriteTextureName = "\(playerTexture)\(i)"
            rightFrames.append(spriteAnimatedAtlas.textureNamed(spriteTextureName))
        }
        playerAgent?.delegate = self

        let behavior = GKBehavior()
        playerAgent?.behavior = behavior
        spriteStillFrame = spriteAnimatedAtlas.textureNamed("\(playerTexture)5")
        spriteLeftFrames = leftFrames
        spriteRightFrames = rightFrames
    }
    
    func holdItemFrames(item: String) {
        let spriteAnimatedAtlas = SKTextureAtlas(named: playerTexture)
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []
        for i in 2...4 {
            let spriteTextureName = "\(playerTexture)\(item)\(i)"
            leftFrames.append(spriteAnimatedAtlas.textureNamed(spriteTextureName))
        }
        for i in 6...8 {
            let spriteTextureName = "\(playerTexture)\(item)\(i)"
            rightFrames.append(spriteAnimatedAtlas.textureNamed(spriteTextureName))
        }
        playerAgent?.delegate = self

        let behavior = GKBehavior()
        playerAgent?.behavior = behavior
        spriteStillFrame = spriteAnimatedAtlas.textureNamed("\(playerTexture)\(item)5")
        spriteLeftFrames = leftFrames
        spriteRightFrames = rightFrames
    }
    
    func resetFrames() {
        let spriteAnimatedAtlas = SKTextureAtlas(named: playerTexture)
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []
        for i in 2...4 {
            let spriteTextureName = "\(playerTexture)\(i)"
            leftFrames.append(spriteAnimatedAtlas.textureNamed(spriteTextureName))
        }
        for i in 6...8 {
            let spriteTextureName = "\(playerTexture)\(i)"
            rightFrames.append(spriteAnimatedAtlas.textureNamed(spriteTextureName))
        }
        playerAgent?.delegate = self

        let behavior = GKBehavior()
        playerAgent?.behavior = behavior
        spriteStillFrame = spriteAnimatedAtlas.textureNamed("\(playerTexture)5")
        spriteLeftFrames = leftFrames
        spriteRightFrames = rightFrames
    }

    func move(direction: String) {
        if (direction == "left") {
            walkLeft()
        } else if direction == "right" {
            walkRight()
        }
    }
    
    private func walkLeft() -> Void {
        node.removeAllActions()
        node.run(SKAction.repeat(
            SKAction.animate(
                with: spriteLeftFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: false
            ), count: 2
        ), withKey: "WALK_LEFT")
    }
    
    private func walkRight() -> Void {
        node.removeAllActions()
        node.run(SKAction.repeat(
            SKAction.animate(
                with: spriteRightFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: false
            ), count: 2
        ), withKey: "WALK_RIGHT")
    }
    
    func faceForward() -> Void {
        node.texture = spriteStillFrame
        node.removeAllActions()
    }
    
    func jump() {
        if let component = entity?.component(ofType: SpriteComponent.self) {
            component.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 55))
        }
    }
    

    
    func agentWillUpdate(_ agent: GKAgent) {
          if let agent2d = agent as? GKAgent2D {
              agent2d.position = SIMD2<Float>(Float((node.position.x)), Float((node.position.y)))
          }
      }
      
      func agentDidUpdate(_ agent: GKAgent) {
          if let agent2d = agent as? GKAgent2D {
              node.position = CGPoint(x: CGFloat(agent2d.position.x), y: CGFloat(agent2d.position.y))
          }
      }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
