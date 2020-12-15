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
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        if let agent = agent as? GKAgent2D,
           let animation = entity?.component(ofType: MovementComponent.self) {
            agent.position = SIMD2<Float>(Float((node.position.x)), Float((node.position.y)))
            if agent.velocity.x < 0 {
                animation.move(direction: "left")
            } else if agent.velocity.x > 0 {
                animation.move(direction: "right")
            } else {
                animation.faceForward()
            }
        }
    }
    
    func setUpAgent(with goals: [GKGoal]) -> GKAgent2D {
        let behavior = GKBehavior(goals: goals, andWeights: [15, 10, 5])
        agent.behavior = behavior
        let position = node.position
        agent.maxSpeed = Float(enemyTopSpeed)
        agent.maxAcceleration = Float(Double(enemyTopSpeed) * 0.1)
        
        agent.radius = 100
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.delegate = self
        return agent
    }
      
}
