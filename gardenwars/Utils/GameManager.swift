import Foundation
import SpriteKit
import GameplayKit
import GameKit
import AVFoundation


var backgroundMusicPlayer: AVAudioPlayer!
let menuTheme = Bundle.main.url(forResource: "menutheme", withExtension: "wav")!
let mainTheme = Bundle.main.url(forResource: "yellowcopter", withExtension: "wav")!
let finishTheme = Bundle.main.url(forResource: "yellowcopter-sting", withExtension: "wav")!



func toggleGameCenterVisibility(_ visible: Bool) {
//    GKAccessPoint.shared.location = .topLeading
//    GKAccessPoint.shared.isActive = visible
}

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
            if (DeviceType.isiPad || DeviceType.isiPadPro) {
                scene.scaleMode = .resizeFill
            } else {
                scene.scaleMode = .resizeFill
            }
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
            gameTimer = 0
            timesecond = 0
            playBackgroundMusic()
            toggleGameCenterVisibility(false)
            return loadResponsiveSizeLevel(level: 1)
        case SceneType.Level2:
            return loadResponsiveSizeLevel(level: 2)
        case SceneType.Level3:
            return loadResponsiveSizeLevel(level: 3)
        case SceneType.GameOver:
            toggleGameCenterVisibility(true)
            playStinger()
            return GameOver(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        }
    }
    
    func loadResponsiveSizeLevel(level: Int) -> SKScene? {
        if (DeviceType.isiPhoneX) {
            return GamePlay(fileNamed: "Level\(level)-medium")
        } else if (DeviceType.isiPad || DeviceType.isiPadPro) {
            return GamePlay(fileNamed: "Level\(level)-large")
        } else {
            return GamePlay(fileNamed: "Level\(level)")
        }
    }
    
}



