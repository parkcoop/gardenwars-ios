/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A state for use in a dispenser's state machine. This state represents when the dispenser is full. It turns on the dispenser's indicator light.
*/

import SpriteKit
import GameplayKit

class HoldingItemState: GardeningState {
    
    // MARK: Initialization
    
    required init(game: GamePlay) {
        super.init(game: game, associatedNodeName: "FullState")
    }
    
    // MARK: GKState overrides
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
//        game.adjustGoalsBasedOnState(state: GKState)

    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        // This state can only transition to the serve state.
        return stateClass is NormalState.Type
    }
}
