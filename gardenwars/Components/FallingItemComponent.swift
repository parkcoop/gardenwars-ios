//
//  FallingItemComponent.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/22/20.
//

import Foundation
import SpriteKit
import GameplayKit

class FallingItemComponent: GKComponent, GKAgentDelegate {
    
    private var spriteComponent: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
        

    func skyFall() -> Void {
        if let spriteComponent = spriteComponent {
          
        
            let actualX = CGFloat.random(in: 0...ScreenSize.width)
            let actualDuration = CGFloat.random(in: CGFloat(2.0)...CGFloat(4.0))
            let actionMove = SKAction.move(to: CGPoint(x: actualX, y: 55),
                                           duration: TimeInterval(actualDuration))

            spriteComponent.node.position = CGPoint(x: actualX, y: 200)
            spriteComponent.node.run(actionMove)
        }
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        if let spriteComponent = spriteComponent {

          if let agent2d = agent as? GKAgent2D {
            agent2d.position = SIMD2<Float>(Float((spriteComponent.node.position.x)), Float((spriteComponent.node.position.y)))
          }
        }
      }
      
  func agentDidUpdate(_ agent: GKAgent) {
    if let spriteComponent = spriteComponent {

      if let agent2d = agent as? GKAgent2D {
        spriteComponent.node.position = CGPoint(x: CGFloat(agent2d.position.x), y: CGFloat(agent2d.position.y))
      }

    }
    }
    
}
