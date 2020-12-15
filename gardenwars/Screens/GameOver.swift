import SpriteKit
import GameKit

class GameOver: SKScene {
    
    
    override func didMove(to view: SKView) {
       
        if player1Wins > player2Wins {
            submitScore()
        }
        
        let displayText = player1Wins > player2Wins ? "Well done, gardener." : "Robot gardeners will take over."
        let endGameLabel: SKLabelNode = SKLabelNode(text: displayText)
        
        let creditText = "Created by Parker Cooper | Artwork by Andriw Tapanes"
        let creditLabel = SKLabelNode(text: creditText)
        creditLabel.fontName = systemFont
        creditLabel.fontSize = 12
        creditLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.1)
        addChild(creditLabel)
        endGameLabel.fontName = systemFont
        endGameLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        endGameLabel.fontSize = 18
        addChild(endGameLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player1Wins = 0
        player2Wins = 0
        startGame()
    }
    
    
    func submitScore() {
        if #available(iOS 14, *) {
            if GKLocalPlayer.local.isAuthenticated {
                leaderboard.submitScore(gameTimer, context: 1, player: GKLocalPlayer.local) { (error) in
                    if error != nil {
                        print(error!)
                    }
                    print("Submitted \(gameTimer) to \(leaderboard.baseLeaderboardID)")
                }
            }
        }
    }
    
    @objc func startGamePlayNotification(_ info:Notification) {
        startGame()
    }
    
    func startGame() {
        GameManager.shared.transition(self, toScene: .MainMenu, transition:
                                        SKTransition.fade(with: UIColor.black, duration: 2))
    }
}
