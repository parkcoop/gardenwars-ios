import SpriteKit

class GameOver: SKScene {
    
    
    override func didMove(to view: SKView) {
        let displayText = player1Wins > player2Wins ? "Well done, gardener." : "Robot gardeners will take over"
        let settingsLabel: SKLabelNode = SKLabelNode(text: displayText)
        settingsLabel.fontName = systemFont
        settingsLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        settingsLabel.fontSize = 12
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
        GameManager.shared.transition(self, toScene: .MainMenu, transition:
                                        SKTransition.fade(with: UIColor.black, duration: 2))
    }
}
