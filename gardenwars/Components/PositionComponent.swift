//
//  PositionComponent.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/22/20.
//

import Foundation
import SpriteKit
import GameplayKit

class PositionComponent : GKComponent {
    // 1.
    var currentPosition : CGPoint
    // 2.
    init(pos : CGPoint){
        self.currentPosition = pos
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
