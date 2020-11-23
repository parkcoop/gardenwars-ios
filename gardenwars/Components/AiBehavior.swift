//
//  MonsterBehavior.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class AiBehavior: GKBehavior {

  init(targetSpeed: Float, seek: GKAgent) {
    super.init()
    if targetSpeed > 0 {
      setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
    }
  }

}
