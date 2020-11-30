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
    
    /// The name of the node in the game scene that is associated with this state.
    let associatedNodeName: String
    
    /// Convenience property to get the state's associated sprite node.
    var associatedNode: SKSpriteNode? {
        return game.childNode(withName: "//\(associatedNodeName)") as? SKSpriteNode
    }
    
    // MARK: Initialization
    
    init(game: GamePlay, associatedNodeName: String) {
        self.game = game
        self.associatedNodeName = associatedNodeName
    }
    
    // MARK: GKState overrides
    
    /// Highlights the sprite representing the state.
    override func didEnter(from previousState: GKState?) {
        guard let associatedNode = associatedNode else { return }
        associatedNode.color = SKColor.lightGray
    }
    
    /// Unhighlights the sprite representing the state.
    override func willExit(to nextState: GKState) {
        guard let associatedNode = associatedNode else { return }
        associatedNode.color = SKColor.darkGray
    }
    
    // MARK: Methods

    /// Changes the Gardening's indicator light to the specified color.
    func changeIndicatorLightToColor(_ color: SKColor) {
        let indicator = game.childNode(withName: "//indicator") as! SKSpriteNode
        indicator.color = color
    }
}
