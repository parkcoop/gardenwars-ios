import SpriteKit

class GameOver: SKScene {
  
    
    override func didMove(to view: SKView) {
        let settingsLabel: SKLabelNode = SKLabelNode(text: "Well done, gardener")
        settingsLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        addChild(settingsLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startGame()
    }
    
    func setupNodes() {
        
    }
    
    func addNodes() {
        
    }
    
    @objc func startGamePlayNotification(_ info:Notification) {
        startGame()
    }

    func startGame() {
        GameManager.shared.transition(self, toScene: .Gameplay, transition:
                                        SKTransition.fade(with: UIColor.black, duration: 2))
    }
}
