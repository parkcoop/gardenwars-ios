//
//  MovementComponent.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/22/20.
//
import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    private var player1LeftFrames: [SKTexture] = []
    private var player1RightFrames: [SKTexture] = []
    private var player1StillFrame: SKTexture?
    
    private var player1WaterLeftFrames: [SKTexture] = []
    private var player1WaterRightFrames: [SKTexture] = []
    private var player1WaterStillFrames: [SKTexture] = []
    
    private var player1SunLeftFrames: [SKTexture] = []
    private var player1SunRightFrames: [SKTexture] = []
    private var player1SunStillFrames: [SKTexture] = []
    
    
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
        if (node.action(forKey: "WALK_LEFT") != nil) {
            return
        }
        node.run(SKAction.repeat(
            SKAction.animate(
                with: player1LeftFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: false
            ), count: 2
        ), withKey: "WALK_LEFT")
    }
    
    private func walkRight() -> Void {
        if (node.action(forKey: "WALK_RIGHT") != nil) {
            return
        }
        node.run(SKAction.repeat(
            SKAction.animate(
                with: player1RightFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: false
            ), count: 2
        ), withKey: "WALK_RIGHT")
    }
    
    
//    func faceForward() -> Void {
//        if node.currentItem == "water" {
//            self.texture = SKTexture(imageNamed: "image/parker_water")
//        } else if self.currentItem == "sun" {
//            self.texture = SKTexture(imageNamed: "image/parker_sun")
//        } else {
//            self.texture = player1StillFrame
//        }
//    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
