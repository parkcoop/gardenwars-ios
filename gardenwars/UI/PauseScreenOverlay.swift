import SpriteKit
import UIKit

class PauseScreenOverlay: SKNode {
    var background = SKSpriteNode(imageNamed: "image/menu")
//    let slider = UISlider(frame: CGRect(x: 250, y: 250, width: 280, height: 20))

    override init() {
        super.init()
        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        background.scaleTo(screenWidthPercentage: 80)
        background.scale(to: CGSize(width: ScreenSize.width * 0.8, height: ScreenSize.height * 0.8))
        addChild(background)
        
    }
    
    
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
}
