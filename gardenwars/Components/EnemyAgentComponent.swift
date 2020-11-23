//
//  EnemyAgentComponent.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/22/20.
//

import SpriteKit
import GameplayKit

class EnemyAgentComponent: GKComponent, GKAgentDelegate {

    private var node: SKSpriteNode {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else {
            fatalError("This entity don't have node")
        }
        return node
    }
    
    override init() {
         super.init()
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
     }
    
    
    func agentDidUpdate(_ agent: GKAgent) {
          if let agent = agent as? GKAgent2D  {
              node.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
          }
      }
      
      func agentWillUpdate(_ agent: GKAgent) {
          if let agent = agent as? GKAgent2D  {
              agent.position = float2(Float((node.position.x) ?? 5), Float((node.position.y)))
          }
      }
    
    
    func setUpAgent(with goals: [GKGoal]) -> GKAgent2D {
           let agent = GKAgent2D()
           let behavior = GKBehavior(goals: goals, andWeights: [1, 0])
           agent.behavior = behavior
           let position = node.position
           agent.maxSpeed = 400
           agent.maxAcceleration = 400
           agent.radius = 40
           agent.position = vector_float2(Float(position.x), Float(position.y))
           agent.delegate = self
           return agent
       }
}
