import Foundation
import SpriteKit
import GameplayKit

let AppId = "123456"
let chartboostAppID = "5a3cfaf8e6d7050d5c5c6dce"
let chartboostAppSignature = "97a43ed515d78826130881e8c0eed747185d0d74"

class GameManager {
    
    enum SceneType {
        case MainMenu,
             Gameplay,
             Settings,
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
            return MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        case SceneType.Gameplay:
            return GamePlay(fileNamed: "GamePlay")
        case SceneType.Settings:
            return Settings(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        case SceneType.GameOver:
            return GameOver(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        }
    }
    
    func run(_ fileName: String, onNode: SKNode) {
            onNode.run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
    }
    
    func showAlert(on scene: SKScene, title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction], animated: Bool = true, delay: Double = 0.0, completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alert.addAction(action)
        }
        
        let wait = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: wait) {
            scene.view?.window?.rootViewController?.present(alert, animated: animated, completion: completion)
        }
        
    }
    
    func share(on scene: SKScene, text: String, image: UIImage?, exculdeActivityTypes: [UIAlertController.Type] ) {
        // text to share
        //let text = "This is some text that I want to share."
        guard let image = image else {return}
        // set up activity view controller
        let shareItems = [ text, image ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = scene.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //    activityViewController.excludedActivityTypes = exculdeActivityTypes
        
        // present the view controller
        scene.view?.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
}



