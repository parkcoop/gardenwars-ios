import SpriteKit
import UIKit

class PauseScreenOverlay: SKNode {
    var background = SKSpriteNode(imageNamed: "image/menu")
//    let slider = UISlider(frame: CGRect(x: 250, y: 250, width: 280, height: 20))
    let musicLabel = SKLabelNode(fontNamed: systemFont)
    let soundEffectsLabel = SKLabelNode(fontNamed: systemFont)
    let exitLabel = SKLabelNode(fontNamed: systemFont)
    let closeLabel = SKLabelNode(fontNamed: systemFont)

    override init() {
        super.init()
        background.name = "background"
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.scaleTo(screenWidthPercentage: 80)
        background.scale(to: CGSize(width: ScreenSize.width * 0.8, height: ScreenSize.height * 0.8))
        addChild(background)
        
        musicLabel.name = "disableMusic"
        musicLabel.text = "Disable music"
        musicLabel.position = CGPoint(x: background.frame.midX, y: background.frame.minY + (background.frame.height * 0.775))
        musicLabel.zPosition = 50
        musicLabel.fontSize = 14
        
        soundEffectsLabel.name = "disableFx"
        soundEffectsLabel.text = "Disable sound effects"
        soundEffectsLabel.position = CGPoint(x: background.frame.midX, y: background.frame.minY + (background.frame.height * 0.575))
        soundEffectsLabel.zPosition = 50
        soundEffectsLabel.fontSize = 14
        
        exitLabel.name = "exit"
        exitLabel.text = "Back to main menu"
        exitLabel.position = CGPoint(x: background.frame.midX, y: background.frame.minY + (background.frame.height * 0.375))
        exitLabel.zPosition = 50
        exitLabel.fontSize = 14
        
        closeLabel.name = "close"
        closeLabel.text = "Close"
        closeLabel.position = CGPoint(x: background.frame.midX, y: background.frame.minY + (background.frame.height * 0.175))
        closeLabel.zPosition = 50
        closeLabel.fontSize = 14
        
        addChild(musicLabel)
        addChild(soundEffectsLabel)
        addChild(exitLabel)
        addChild(closeLabel)

        
    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchedNode = self.nodes(at: location)
//            for node in touchedNode {
////                switch node.name {
////                case "fxEnabled":
////                    masterEffectsVolume = 0.25
////                case "fxDisabled":
////                    masterEffectsVolume = 0.00
////                case "musicEnabled":
////                    masterMusicVolume = 0.25
////                case "musicEnabled":
////                    masterMusicVolume = 0.00
////                case "exit":
////                    GameManager.shared.transition(self.scene!, toScene: .MainMenu, transition:
////                                                    SKTransition.fade(with: UIColor.black, duration: 1))
////                default:
////                    print("LOL")
////                }
//            }
//        }
//    }
//
    
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
}
