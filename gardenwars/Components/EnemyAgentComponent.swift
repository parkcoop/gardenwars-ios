//
//  EnemyAgentComponent.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/22/20.
//

import SpriteKit
import GameplayKit

class EnemyAgentComponent: GKComponent, GKAgentDelegate {
    
    let agent: GKAgent2D

    private var node: SKSpriteNode {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else {
            fatalError("This entity doesn't have a node")
        }
        return node
    }
    
    override init() {
        agent = GKAgent2D()

        super.init()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func agentDidUpdate(_ agent: GKAgent) {
        if let agent = agent as? GKAgent2D  {
            node.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
        }
//        guard let animation = entity?.component(ofType: MovementComponent.self) else {
//            fatalError()
//        }
////        print(node.physicsBody!.velocity)
//        if node.physicsBody!.velocity.dx > 0 {
//            animation.move(direction: "left")
//        } else if node.physicsBody!.velocity.dx < 0 {
//            animation.move(direction: "right")
//        } else {
//            animation.faceForward()
//        }
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        if let agent = agent as? GKAgent2D  {
            agent.position = float2(Float((node.position.x)), Float((node.position.y)))
        }
        guard let aiEnemyBody = entity?.component(ofType: PhysicsComponent.self) else {
            fatalError("Enemy needs a physics component")
        }
        guard let animation = entity?.component(ofType: MovementComponent.self) else {
            fatalError("Enemy needs animation/movement component")
        }
        print(node.physicsBody!.velocity.dx, aiEnemyBody.physicsBody.velocity.dx)
        if node.physicsBody!.velocity.dx > 0 {
            animation.move(direction: "left")
        } else if node.physicsBody!.velocity.dx < 0 {
            animation.move(direction: "right")
        } else {
            animation.faceForward()
        }
    }
    //// MARK: `lol` omg
    func getPosition() -> vector_float2 {
        let position = node.position
        
        return vector_float2(Float(position.x), Float(position.y))
    }
    
    func setUpAgent(with goals: [GKGoal]) -> GKAgent2D {
        let behavior = GKBehavior(goals: goals, andWeights: [15, 10, 5, 1])
        agent.behavior = behavior
        let position = node.position
        agent.maxSpeed = 3000
        agent.maxAcceleration = 3000
        
        agent.radius = 100
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.delegate = self
        return agent
    }
      
}
