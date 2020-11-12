import SpriteKit

class Settings: SKScene {
  
    
    override func didMove(to view: SKView) {
        let settingsLabel: SKLabelNode = SKLabelNode(text: "Settings")
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
