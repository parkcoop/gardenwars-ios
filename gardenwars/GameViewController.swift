import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var currentLevel = 1
var player1Wins = 0
var player2Wins = 0

class GameViewController: UIViewController {
    
    
    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
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
