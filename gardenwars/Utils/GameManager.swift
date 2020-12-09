import Foundation
import SpriteKit
import GameplayKit
import AVFoundation


var backgroundMusicPlayer: AVAudioPlayer!
let menuTheme = Bundle.main.url(forResource: "menutheme", withExtension: "wav")!
let mainTheme = Bundle.main.url(forResource: "yellowcopter", withExtension: "wav")!
let finishTheme = Bundle.main.url(forResource: "yellowcopter-sting", withExtension: "wav")!


func playMenuTheme() {
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: menuTheme)
        backgroundMusicPlayer.numberOfLoops = 250
        backgroundMusicPlayer.volume = 0.05
//        backgroundMusicPlayer.currentTime = TimeInterval(2)
        backgroundMusicPlayer.play()

    }
    catch {
        print(error)
    }
}

func playBackgroundMusic() {
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: mainTheme)
        backgroundMusicPlayer.numberOfLoops = 5
        backgroundMusicPlayer.volume = 0.05
//        backgroundMusicPlayer.currentTime = TimeInterval(2)
        backgroundMusicPlayer.play()

    }
    catch {
        print(error)
    }
}

func playStinger() {
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: finishTheme)
        backgroundMusicPlayer.numberOfLoops = 0
        backgroundMusicPlayer.volume = 0.05
        backgroundMusicPlayer.play()

    }
    catch {
        print(error)
    }
}

var playerSpriteSize = CGSize(width: 40, height: 75)
var chosenCharacter = "parker"
var enemyCharacter = "enemy"
var enemyPredictionTime = 1
var enemyTopSpeed = 750
var systemFont = "8-bit-pusab"

class GameManager {
    
    enum SceneType {
        case MainMenu,
             Gameplay,
             Level2,
             Level3,
             GameOver
    }
    
    private init() {}
    static let shared = GameManager()
    
    public func launch() {
        firstLaunch()
    }
    
    
    private func firstLaunch() {
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            
            print("This is our first launch")
            //            PlayerStats.shared.setSounds(true)
            //            PlayerStats.shared.saveMusicVolume(0.7)
            
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            UserDefaults.standard.synchronize()
        }
    }
    
    func transition(_ fromScene: SKScene, toScene: SceneType, transition: SKTransition? = nil ) {
        guard let scene = getScene(toScene) else { return }
        
        if let transition = transition {
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0, y: 0)
            
            fromScene.view?.presentScene(scene, transition: transition)
        } else {
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0, y: 0)
            
            fromScene.view?.presentScene(scene)
        }
        
    }
    
    func getScene(_ sceneType: SceneType) -> SKScene? {
        switch sceneType {
        case SceneType.MainMenu:
            playMenuTheme()
            return MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        case SceneType.Gameplay:
            playBackgroundMusic()

            if (DeviceType.isiPhoneX) {
                return GamePlay(fileNamed: "Level1-medium")
            } else {
                return GamePlay(fileNamed: "Level1")
            }
        case SceneType.Level2:
            if (DeviceType.isiPhoneX) {
                return GamePlay(fileNamed: "Level2-medium")
            } else {
                return GamePlay(fileNamed: "Level2")
            }
        case SceneType.Level3:
            if (DeviceType.isiPhoneX) {
                return GamePlay(fileNamed: "Level3-medium")
            } else {
                return GamePlay(fileNamed: "Level3")
            }
        case SceneType.GameOver:
            playStinger()
            return GameOver(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        }
    }
    
    //    func run(_ fileName: String, onNode: SKNode) {
    //            onNode.run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
    //    }
    
    //    func showAlert(on scene: SKScene, title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction], animated: Bool = true, delay: Double = 0.0, completion: (() -> Swift.Void)? = nil) {
    //        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    //
    //        for action in actions {
    //            alert.addAction(action)
    //        }
    //
    //        let wait = DispatchTime.now() + delay
    //        DispatchQueue.main.asyncAfter(deadline: wait) {
    //            scene.view?.window?.rootViewController?.present(alert, animated: animated, completion: completion)
    //        }
    //
    //    }
    
    //    func share(on scene: SKScene, text: String, image: UIImage?, exculdeActivityTypes: [UIAlertController.Type] ) {
    //        // text to share
    //        //let text = "This is some text that I want to share."
    //        guard let image = image else {return}
    //        // set up activity view controller
    //        let shareItems = [ text, image ] as [Any]
    //        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    //        activityViewController.popoverPresentationController?.sourceView = scene.view // so that iPads won't crash
    //
    //        // exclude some activity types from the list (optional)
    //        //    activityViewController.excludedActivityTypes = exculdeActivityTypes
    //
    //        // present the view controller
    //        scene.view?.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    //    }
    
}



