//
//  MainMenu.swift
//  gardenwars
//
//  Created by Parker Cooper on 11/7/20.
//

import SpriteKit

class MainMenu: SKScene {
    var background = SKSpriteNode(imageNamed: "image/sky")
    let logo = SKSpriteNode(imageNamed: "image/logo")

//
    lazy var playButton: ActionButton = {
        var button = ActionButton(imageNamed: "image/logo", buttonAction: {
            print("lol")
        })
        button.zPosition = 1
        return button
    }()
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.size = self.frame.size
        background.zPosition = -5
        playButton.scaleTo(screenWithPercentage: 0.33)
        addChild(background)
        addChild(playButton)

        let welcomeLabel = SKLabelNode(fontNamed: "Chalkduster")
        welcomeLabel.text = "Tap the sceen to begin"
        welcomeLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2 - 100)
        playButton.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        welcomeLabel.zPosition = 6
        welcomeLabel.fontSize = 26
        welcomeLabel.fontColor = UIColor.black
        welcomeLabel.alpha = 1
        addChild(welcomeLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let level1 = SKScene(fileNamed: "GameScene")
//        level1?.scaleMode = .resizeFill
//        self.view?.presentScene(level1)
        startGamePlay()
    }
    
    func setupNodes() {
        
    }
    
    func addNodes() {
        
    }
    
    @objc func startGamePlayNotification(_ info:Notification) {
        startGamePlay()
    }

    func startGamePlay() {
        GameManager.shared.transition(self, toScene: .Gameplay, transition:
                                        SKTransition.fade(with: UIColor.black, duration: 2))
    }
}
