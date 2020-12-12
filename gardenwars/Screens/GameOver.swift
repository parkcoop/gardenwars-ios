import SpriteKit
import GameKit

class GameOver: SKScene {
    
    
    override func didMove(to view: SKView) {
        print("SUBMITTING TO", leaderboard)
        print("USER?", GKLocalPlayer.local)
//        leaderboard.submitScore(gameTimer, context: 1, player: GKLocalPlayer.local) { (error) in
//            if error != nil {
//                print(error!)
//            }
//            print("NICEEEEEE")
//        }
        let displayText = player1Wins > player2Wins ? "Well done, gardener." : "Robot gardeners will take over"
        let endGameLabel: SKLabelNode = SKLabelNode(text: displayText)
        endGameLabel.fontName = systemFont
        endGameLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        endGameLabel.fontSize = 12
        addChild(endGameLabel)
    }
    
    func submittedScore(_ err: Error?) -> Void {
        print(err)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player1Wins = 0
        player2Wins = 0
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
