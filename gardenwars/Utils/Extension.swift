import UIKit
import SpriteKit
import AVFoundation

struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

struct DeviceType {
    static let isiPhone4OrLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength < 568.0
    static let isiPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
    static let isiPhone6Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength > 812.0
    static let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    static let isiPadPro = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1366.0
    
}

public extension CGFloat {
    static func universalFont(size: CGFloat) -> CGFloat {
        if DeviceType.isiPhone4OrLess {
            return size * 0.6
        }
        
        if DeviceType.isiPhone5 {
            return size * 0.8
        }
        
        if DeviceType.isiPhone6 {
            return size * 1.0
        }
        
        if DeviceType.isiPhone6Plus {
            return size * 1.0
        }
        
        if DeviceType.isiPhoneX {
            return size * 1.0
        }
        
        if DeviceType.isiPad {
            return size * 2.1
        }
        
        if DeviceType.isiPadPro {
            return size * 2.1
        } else {
            return size * 1.0
        }
    }
    
}

public extension SKAction {

    public class func playSoundFileNamed(fileName: String, atVolume: Float, waitForCompletion: Bool) -> SKAction {
    
    let nameOnly = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
    let fileExt  = fileName.pathExtension
    
    let soundPath = Bundle.main.url(forResource: nameOnly, withExtension: fileExt)
    
    var player: AVAudioPlayer!
    do {
       player = try AVAudioPlayer(contentsOf: soundPath!)
    } catch {
        debugPrint("Error with playing soundFile: \(error.localizedDescription)")
    }
    
    player.volume = atVolume
    
    let playAction: SKAction = SKAction.run { () -> Void in
        player.play()
    }
    
    if(waitForCompletion){
        let waitAction = SKAction.wait(forDuration: player.duration)
        let groupAction: SKAction = SKAction.group([playAction, waitAction])
        return groupAction
    }
    
    return playAction
 }
}

extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String {
        return ns.pathExtension
    }
    var lastPathComponent: String {
        return ns.lastPathComponent
    }
}
extension SKSpriteNode {
    
    func scaleTo(screenWidthPercentage: CGFloat) {
        let aspectRatio = self.size.height / self.size.width
        self.size.width = ScreenSize.width * screenWidthPercentage
        self.size.height = self.size.width * aspectRatio
    }
    
    func scaleTo(screenHeightPercentage: CGFloat) {
        let aspectRatio = self.size.width / self.size.height
        self.size.height = ScreenSize.height * screenHeightPercentage
        self.size.width = self.size.height * aspectRatio
    }
    
    
}



