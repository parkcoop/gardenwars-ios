/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A superclass for states powering the Gardening.
*/

import SpriteKit
import GameplayKit

class GardeningState: GKState {
    // MARK: Properties
    
    /// A reference to the game scene, used to alter sprites.
    let game: GamePlay

    
    // MARK: Initialization
    
    init(game: GamePlay) {
        self.game = game

    }

}
