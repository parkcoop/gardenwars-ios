//
//  MovementComponent.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/22/20.
//
import SpriteKit
import GameplayKit

class MovementComponent: GKComponent, GKAgentDelegate {
    private var player1LeftFrames: [SKTexture] = []
    private var player1RightFrames: [SKTexture] = []
    private var player1StillFrame: SKTexture?
    
    private var player1WaterLeftFrames: [SKTexture] = []
    private var player1WaterRightFrames: [SKTexture] = []
    private var player1WaterStillFrames: [SKTexture] = []
    
    private var player1SunLeftFrames: [SKTexture] = []
    private var player1SunRightFrames: [SKTexture] = []
    private var player1SunStillFrames: [SKTexture] = []
    
    var playerAgent: GKAgent2D? = GKAgent2D()

    private var node: SKSpriteNode {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else {
            fatalError("This entity don't have node")
        }
        return node
    }

    override init() {
        super.init()
        let player1AnimatedAtlas = SKTextureAtlas(named: "parker")
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []
        for i in 2...4 {
            let player1TextureName = "\("parker")\(i)"
            leftFrames.append(player1AnimatedAtlas.textureNamed(player1TextureName))
        }
        for i in 6...8 {
            let player1TextureName = "\("parker")\(i)"
            rightFrames.append(player1AnimatedAtlas.textureNamed(player1TextureName))
        }
        playerAgent?.delegate = self

        let behavior = GKBehavior()
        playerAgent?.behavior = behavior
        player1StillFrame = player1AnimatedAtlas.textureNamed("\("parker")5")
        player1LeftFrames = leftFrames
        player1RightFrames = rightFrames
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
//        if (node.action(forKey: "WALK_LEFT") != nil) {
//            return
//        }
        node.run(SKAction.repeatForever(
            SKAction.animate(
                with: player1LeftFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: false
            )
        ), withKey: "WALK_LEFT")
    }
    
    private func walkRight() -> Void {
        node.removeAllActions()

        node.run(SKAction.repeatForever(
            SKAction.animate(
                with: player1RightFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: false
            )
        ), withKey: "WALK_RIGHT")
    }
    
    func jump() {
        if let component = entity?.component(ofType: SpriteComponent.self) {
            component.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 55))
        }
    }
    
    func faceForward() -> Void {
        print("WTF")
//        if node.currentItem == "water" {
//            node.texture = SKTexture(imageNamed: "image/parker_water")
//        } else if node.currentItem == "sun" {
//            node.texture = SKTexture(imageNamed: "image/parker_sun")
//        } else {
        node.texture = player1StillFrame

        node.removeAllActions()
//        }
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
