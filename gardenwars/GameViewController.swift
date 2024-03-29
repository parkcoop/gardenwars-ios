import UIKit
import SpriteKit
import GameplayKit
import GameKit
import AVFoundation

var currentLevel = 1
var player1Wins = 0
var player2Wins = 0
var leaderboard: GKLeaderboard!

var gameTimer: Int = Int()
var timesecond = Int()
var displayTime: String = "00:00"

var musicEnabled = true

var effectsEnabled = true

class GameViewController: UIViewController {
    
    
    
    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
 
        gameCenterAuthorization()
        toggleGameCenterVisibility(true)
        playMenuTheme()
        super.viewDidLoad()
//        skView.run(SKAction.playSoundFileNamed("yellowcopter.wav", waitForCompletion: false))
        view.addSubview(skView)
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        skView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        skView.showsFPS = true
        let scene = MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
    }
    
    func gameCenterAuthorization() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Present the view controller so the player can sign in
                return
            }
            if error != nil {
                // Player could not be authenticated
                // Disable Game Center in the game
                return
            }
            
            // Player was successfully authenticated
            // Check if there are any player restrictions before starting the game
                    
            if GKLocalPlayer.local.isUnderage {
                // Hide explicit game content
            }
            if #available(iOS 13, *) {
                if GKLocalPlayer.local.isMultiplayerGamingRestricted {
                    // Disable multiplayer game features
                }
                if #available(iOS 14, *) {
                    if GKLocalPlayer.local.isPersonalizedCommunicationRestricted {
                        // Disable in game communication UI
                    }
                    
                    GKLeaderboard.loadLeaderboards(IDs: ["com.parkercoop.gardenwars.besttimes"], completionHandler: { (leaderboards, error) in
            //            leaderboard = leaderboards[0]!
                        if let bestTimes = leaderboards?[0] {
                            leaderboard = bestTimes
                        }
                        print(leaderboard)
                        if (error != nil) {
                            print("LEADERBOARDERROR", error)
                        }
                    })
                }
               
            }

        }
      

    }
    
    func playMenuTheme() {
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: menuTheme)
            backgroundMusicPlayer.numberOfLoops = 50
            backgroundMusicPlayer.volume = 0.05
            backgroundMusicPlayer.play()

        }
        catch {
            print(error)
        }
    }
    
}
