//
//  StartScene.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/6/20.
//

import UIKit
import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    var background = SKSpriteNode(imageNamed: "image/sky")
    let logo = SKSpriteNode(imageNamed: "image/logo")

    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = -5
        logo.position = CGPoint(x: 0, y: 0)
        logo.size = CGSize(width: 200, height: 100)
        logo.zPosition = -5
        addChild(background)
        addChild(logo)

        let welcomeLabel = SKLabelNode(fontNamed: "Chalkduster")
        welcomeLabel.text = "Tap the sceen to begin"
        welcomeLabel.position = CGPoint(x: 0, y: -100)
        welcomeLabel.zPosition = 6
        welcomeLabel.fontSize = 26
        welcomeLabel.fontColor = UIColor.black
        welcomeLabel.alpha = 1
        addChild(welcomeLabel)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("LOL")
        let level1 = SKScene(fileNamed: "GameScene")
        level1?.scaleMode = .aspectFit
        self.view?.presentScene(level1)
    }
    
    
}
