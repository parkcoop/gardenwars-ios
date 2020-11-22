//
//  Enemy.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/18/20.
//

import Foundation
import SpriteKit
import GameplayKit

class Enemy: GKAgent, GKAgentDelegate {
    
    var stateMachine: GKStateMachine?
    var playerState: GKStateMachine?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    func setUpAgent(with goals: [GKGoal]) -> GKAgent2D {
        let agent = GKAgent2D()
        let behavior = GKBehavior(goals: goals, andWeights: [1, 0])
        agent.behavior = behavior
        agent.maxSpeed = 400
        agent.maxAcceleration = 400
        agent.radius = 40
        agent.delegate = self
        return agent
        
        
    }
    
    
    
}
